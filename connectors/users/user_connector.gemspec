$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "user_connector"
  s.version     = '0.0.1'
  s.authors     = ["Sergey Smagin"]
  s.email       = ["smaginsergey1310@gmail.com"]
  s.summary     = "Connector for User table of redmine to Timesheet application."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc", "database_config.yml"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
end
