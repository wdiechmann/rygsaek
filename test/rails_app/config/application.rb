require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "rails/test_unit/railtie"

Bundler.require :default, RYGSAEK_ORM

begin
  require "#{RYGSAEK_ORM}/railtie"
rescue LoadError
end

require "rygsaek"

module RailsApp
  class Application < Rails::Application
    # Add additional load paths for your own custom dirs
    config.autoload_paths.reject!{ |p| p =~ /\/app\/(\w+)$/ && !%w(controllers helpers views).include?($1) }
    config.autoload_paths += [ "#{config.root}/app/#{RYGSAEK_ORM}" ]

    # Configure generators values. Many other options are available, be sure to check the documentation.
    # config.generators do |g|
    #   g.orm             :active_record
    #   g.template_engine :erb
    #   g.test_framework  :test_unit, fixture: true
    # end

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters << :password
    config.assets.enabled = false

  end
end
