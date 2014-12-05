require 'rails/generators/base'

module Rygsaek
  module Generators
    
    # The views generator will add view_path templates
    # 
    #  views/rygsaeks/
    #    _form.html.haml
    #    new.html.haml
    #    edit.html.haml
    #    show.html.haml
    #    index.html.haml
    #  views/rygsaek_items/
    #    _form.html.haml
    #    new.html.haml
    #    edit.html.haml
    #    show.html.haml
    #    index.html.haml
    #  views/rygsaek_item_links/
    #    _link.html.haml
    
    # Include this module in your generator to generate Rygsaek views.
    # `copy_views` is the main method and by default copies all views
    # with forms.
    module ViewPathTemplates #:nodoc:
      extend ActiveSupport::Concern

      included do
        argument :scope, required: false, default: nil,
                         desc: "The scope to copy views to"

        # Le sigh, ensure Thor won't handle opts as args
        # It should be fixed in future Rails releases
        class_option :form_builder, aliases: "-b"
        class_option :markerb
        class_option :views, aliases: "-v", type: :array, desc: "Select specific view directories to generate (rygsaeks, rygsaek_items, rygsaek_item_links)"

        public_task :copy_views
      end

      # TODO: Add this to Rails itself
      module ClassMethods
        def hide!
          Rails::Generators.hide_namespace self.namespace
        end
      end

      def copy_views
        if options[:views]
          options[:views].each do |directory|
            view_directory directory.to_sym
          end
        else
          view_directory :rygsaeks
          view_directory :rygsaek_items
          view_directory :rygsaek_item_links
        end
      end

      protected

      def view_directory(name, _target_path = nil)
        directory name.to_s, _target_path || "#{target_path}/#{name}" do |content|
          if scope
            content.gsub "rygsaek", "#{scope}"
          else
            content
          end
        end
      end

      def target_path
        @target_path ||= "app/views/#{scope || :rygsaek}"
      end
    end

    class SharedViewsGenerator < Rails::Generators::Base #:nodoc:
      include ViewPathTemplates
      source_root File.expand_path("../../../../app/views/rygsaek", __FILE__)
      desc "Copies shared Rygsaek views to your application."
      hide!

      # Override copy_views to just copy mailer and shared.
      def copy_views
        view_directory :shared
      end
    end

    class FormForGenerator < Rails::Generators::Base #:nodoc:
      include ViewPathTemplates
      source_root File.expand_path("../../../../app/views/rygsaek", __FILE__)
      desc "Copies default Rygsaek views to your application."
      hide!
    end

    class SimpleFormForGenerator < Rails::Generators::Base #:nodoc:
      include ViewPathTemplates
      source_root File.expand_path("../../templates/simple_form_for", __FILE__)
      desc "Copies simple form enabled views to your application."
      hide!
    end

    class ViewsGenerator < Rails::Generators::Base
      desc "Copies Rygsaek views to your application."

      argument :scope, required: false, default: nil,
                       desc: "The scope to copy views to"

      invoke SharedViewsGenerator

      hook_for :form_builder, aliases: "-b",
                              desc: "Form builder to be used",
                              default: defined?(SimpleForm) ? "simple_form_for" : "form_for"
    end
  end
end
