require 'rails/generators/base'
require 'securerandom'

module Rygsaek
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Rygsaek initializer and copy locale files to your application."
      class_option :orm

      def copy_initializer
        template "rygsaek.rb", "config/initializers/rygsaek.rb"
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/rygsaek.en.yml"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end

      def rails_4?
        Rails::VERSION::MAJOR == 4
      end
    end
  end
end
