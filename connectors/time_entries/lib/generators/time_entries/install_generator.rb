module TimeEntryConnector::Generators
  class InstallGenerator < ::Rails::Generators::Base
    desc 'Generates a custom config in config/connectors/time_entries.yml'

    def source_paths
      [File.expand_path("../templates", __FILE__)]
    end

    def copy_config
      template 'config.yml', 'config/connectors/time_entries.yml'
    end
  end
end
