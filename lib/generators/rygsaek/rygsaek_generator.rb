require 'rails/generators/named_base'

module Rygsaek
  module Generators
    class RygsaekGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      namespace "rygsaek"
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a model with the given NAME (if one does not exist) with rygsaek " <<
           "configuration plus a migration file and rygsaek routes."

      hook_for :orm

      class_option :routes, desc: "Generate routes", type: :boolean, default: true

      def add_devise_routes
        devise_route  = "rygsaek_on :#{plural_name}"
        devise_route << %Q(, class_name: "#{class_name}") if class_name.include?("::")
        devise_route << %Q(, skip: :all) unless options.routes?
        route devise_route
      end
    end
  end
end
