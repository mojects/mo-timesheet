class UserConnector < ActiveRecord::Base
  def self.configure(path)
    self.const_set :CONFIG, YAML.load_file(path)[Rails.env]
  end

  def self.configure_connector(name, config)
    source = DataSource.find_or_create_by({ name: name,
      config_section_id: name, connector_type: 'redmine' })
    source_id = source.id

    x = Class.new(UserConnector) do
      def self.to_users(user)
        db_user = User.find_by(first_name: user['first_name'],
          last_name: user['last_name'])
        db_user = User.create(user) unless db_user
        DataSourceUser.find_or_create_by(data_source_id: source_id,
          user_id: db_user.id, external_user_id: user['external_user_id'])
        db_user.update user if DataSource.find(source_id).primary?
      end
    end

    x.class_eval <<-RUBY
      def self.source_id; #{source_id}; end
    RUBY

    class_name = "UserConnector#{name.to_s.camelcase}"
    Kernel.const_set class_name, x
    Kernel.const_get(class_name).establish_connection config
    Kernel.const_get(class_name).table_name = 'users'
    Kernel.const_get(class_name).inheritance_column = :_type_disabled
  end

  # Map connector columns to User columns.
  COLUMNS_MAP = {
    'id'         => 'external_user_id',
    'firstname'  => 'first_name',
    'lastname'   => 'last_name',
    'created_on' => 'created_at',
    'updated_on' => 'updated_at' }

  # Get users updated on timeframe from..to and put
  # them to User model.
  #
  # Parameters:
  #   from, to -- Time -- edges of timeframe.
  #
  def self.synchronize(from, to)
    where(updated_on: from..to).map { |x| to_internal_columns x }.
      each { |x| to_users x }
  end

  def self.to_internal_columns(user)
    hash = user.attributes
    COLUMNS_MAP.each do |old, (new, function)|
      next unless hash[old]
      value = hash.delete old
      hash[new] = (function ? send(function, value) : value)
    end
    columns = User.column_names
    hash.select { |k, _| columns.include? k }
  end
end

require_relative 'users/railtie' if defined?(Rails)

UserConnector::VERSION = '0.1.0'
