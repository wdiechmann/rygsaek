module Rygsaek
  
  class Configuration
    attr_accessor :storage
    
    def initialize
      @storage = :file
    end
  end
  
end