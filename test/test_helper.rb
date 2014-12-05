ENV["RAILS_ENV"] = "test"
RYGSAEK_ORM = (ENV["RYGSAEK_ORM"] || :active_record).to_sym

$:.unshift File.dirname(__FILE__)
puts "\n==> Rygsaek.orm = #{RYGSAEK_ORM.inspect}"

require "rails_app/config/environment"
require "rails/test_help"
require "orm/#{RYGSAEK_ORM}"

I18n.load_path << File.expand_path("../support/locale/en.yml", __FILE__)

require 'mocha/setup'
require 'webrat'
Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

# Add support to load paths so we can overwrite broken webrat setup
$:.unshift File.expand_path('../support', __FILE__)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# For generators
# require "rails/generators/test_case"
# require "generators/devise/install_generator"
# require "generators/devise/views_generator"
