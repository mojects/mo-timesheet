class TimeEntryConnector::Railtie < Rails::Railtie
  initializer 'Include connector in the controller' do
    config_path = Rails.root + 'config/connectors/time_entries.yml'
    if File.exists? config_path
      TimeEntryConnector.configure config_path
      TimeEntryConnector::CONFIG.each_pair do |name, config|
        begin
          TimeEntryConnector.configure_connector name, config
        rescue
          puts 'Try to run rake db:migrate'
        end
      end
    else
      puts 'Run `rails g time_entry_connector:install`'
    end
  end

  path = File.expand_path '../../generators/time_entries/install_generator.rb',
    __FILE__
  generators { require path }
end
