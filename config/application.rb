require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Timesheet
  class Application < Rails::Application
    # Whitelist assets to be precompiled.
    #
    # This is a workaround for an issue where the precompilation process will
    # fail on extensionless files (README, LICENSE, etc.)
    # See: https://github.com/sstephenson/sprockets/issues/347
    precompile_whitelist = %w(
      .html .erb .haml
      .png  .jpg .gif .jpeg .ico
      .eot  .otf .svc .woff .ttf
      .svg
    )
    config.assets.precompile.shift
    config.assets.precompile.unshift -> (path) {
      (extension = File.extname(path)).present? and extension.in?(precompile_whitelist)
    }
  end
end
