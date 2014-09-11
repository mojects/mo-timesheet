class UserConnector::Railtie < Rails::Railtie
  initializer 'Include connector in the controller' do
    config_path = Rails.root + 'config/connectors/users.yml'
    if File.exists? config_path
      UserConnector.configure config_path
      UserConnector::CONFIG.each_pair do |name, config|
        begin
          UserConnector.configure_connector name, config
        rescue
          puts 'try to run rake db:migrate'
        end
      end
    else
      puts 'Run `rails g user_connector:install`'
    end
  end

  path = File.expand_path '../../generators/users/install_generator.rb',
    __FILE__
  generators { require path }
end
