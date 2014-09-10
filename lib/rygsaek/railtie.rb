require 'rails'
require 'rygsaek/helper'
require 'rygsaek/enclosure'

module Rygsaek
  class Railtie < Rails::Railtie
    initializer 'rygsaek.action_view' do
      ActiveSupport.on_load(:action_view) do
        include Rygsaek::Helper
      end
    end
    
    initializer 'rygsaek.active_record' do
      ActiveSupport.on_load(:active_record) do
        include Rygsaek::Enclosure
      end
    end
  end
end