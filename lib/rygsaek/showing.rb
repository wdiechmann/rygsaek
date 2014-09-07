module Rygsaek
  class Showing
    
    attr_accessor :config
    
    def initialize(config = Rygsaek.configuration)
      @config = config
    end
    
    def view_a_photo
      ""
    end
  end
end