class TimeEntryConnector < ActiveRecord::Base; end
require_relative 'time_entries/railtie' if defined?(Rails)

class TimeEntryConnector < ActiveRecord::Base
  VERSION = '0.0.1'
  COLUMNS_MAP = {
    'id'         => 'external_id',
    'comments'   => 'comment',
    'user_id'    => ['user_id', :user_id],
    'issue_id'   => ['task', :task],
    'project_id' => ['project', :project] }

  def self.configure(path)
    self.const_set :CONFIG, YAML.load_file(path)[Rails.env]
  end

  def self.configure_connector(name, config)
    source = DataSource.find_or_create_by({ name: name,
      config_section_id: name, connector_type: 'redmine' })

    class_name         = "TimeEntry#{name.to_s.camelcase}"
    issue_class_name   = "Issue#{name.to_s.camelcase}"
    project_class_name = "Project#{name.to_s.camelcase}"
    Kernel.const_set issue_class_name,   Class.new(ActiveRecord::Base)
    Kernel.const_set project_class_name, Class.new(ActiveRecord::Base)

    time_entry_class = Class.new(TimeEntryConnector) do
      def self.user_id(external_user_id)
        DataSourceUser.find_by(external_user_id: external_user_id,
          data_source_id: source_id).user_id
      end

      def self.to_time_entries(time_entry)
        if entry = TimeEntry.find_by(external_id: time_entry['external_id'],
          data_source_id: source_id)
          entry.update(time_entry)
        else
          TimeEntry.create(time_entry.merge(data_source_id: source_id))
        end
      end

      def self.project(project_id)
        project_class.find(project_id).name
      end

      def self.task(issue_id)
        issue_class.find(issue_id).subject
      end
    end

    time_entry_class.class_eval <<-RUBY
      def self.source_id; #{source.id}; end
      def self.issue_class; #{issue_class_name}; end
      def self.project_class; #{project_class_name}; end
    RUBY

    Kernel.const_set class_name, time_entry_class

    # It's a hell. Must be other way to do it.
    Kernel.const_get(class_name).establish_connection config
    Kernel.const_get(class_name).table_name = 'time_entries'

    Kernel.const_get(issue_class_name).establish_connection config
    Kernel.const_get(issue_class_name).table_name = 'issues'

    Kernel.const_get(project_class_name).establish_connection config
    Kernel.const_get(project_class_name).table_name = 'projects'
  end

  def self.synchronize(from, to)
    where(spent_on: from..to).
      map  { |x| to_internal_columns x }.
      each { |x| to_time_entries x }
  end

  def self.to_internal_columns(time_entry)
    hash = time_entry.attributes
    COLUMNS_MAP.each do |old, (new, function)|
      next unless hash[old]
      value = hash.delete old
      hash[new] = (function ? send(function, value) : value)
    end
    columns = TimeEntry.column_names
    hash.select { |k, _| columns.include? k }
  end
end
