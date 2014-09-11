$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "time_entries_connector"
  s.version     = '0.0.1'
  s.authors     = ["Sergey Smagin"]
  s.email       = ["smaginsergey1310@gmail.com"]
  s.summary     = "Connector for TimeEntry table of Redmine to Timesheet application."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "db_config.rb", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
end
