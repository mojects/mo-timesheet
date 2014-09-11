$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "xlsx_import/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "xlsx_import"
  s.version     = XlsxImport::VERSION
  s.authors     = ["Sergey Smagin"]
  s.email       = ["smaginsergey1310@gmail.com"]
  s.homepage    = "https://github.com/s-mage"
  s.summary     = "Import time entries from xlsx"
  s.description = "Plugin for Timesheet that import time entries from xlsx"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "roo"

  s.add_development_dependency "sqlite3"
end
