require 'rails'
require 'rygsaek/helper'

module Rygsaek
  class Railtie < Rails::Railtie
    initializer 'rygsaek.action_view' do
      ActiveSupport.on_load(:action_view) do
        include Rygsaek::Helper
      end
    end
    initializer 'rygsaek.active_record' do

      # Extend ActiveRecord's functionality
      ActiveRecord::Base.send :extend, Rygsaek::Enclosure
      
    end
  end
end