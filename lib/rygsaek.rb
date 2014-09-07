require "rygsaek/version"
require "rygsaek/configuration"
require "rygsaek/showing"

# be prepared to rescue this
# pry will only be available to development
begin
  require "pry" 
  # pry is available now
  # binding.pry
rescue LoadError 
end

module Rygsaek
  class << self
    attr_accessor :configuration
  end
  
  def self.configuration
    @configuration ||= Configuration.new
  end
  
  def self.reset
    @configuration = Configuration.new
  end
  
  def self.configure
    yield(configuration)
  end
end
