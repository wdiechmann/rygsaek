require 'rails/generators/active_record'
require 'generators/rygsaek/orm_helpers'

module ActiveRecord
  module Generators
    class RygsaekGenerator < ActiveRecord::Generators::Base
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      include Rygsaek::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      def copy_rygsaek_migration
        migration_template "migration.rb", "db/migrate/create_rygsaek_tables.rb"
      end

      def generate_model
        invoke "active_record:model", [name], migration: false unless model_exists? && behavior == :invoke
      end

      def inject_rygsaek_content
        # content = model_contents
        #
        # class_path = if namespaced?
        #   class_name.to_s.split("::")
        # else
        #   [class_name]
        # end
        #
        # indent_depth = class_path.size - 1
        # content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"
        #
        # inject_into_class(model_path, class_path.last, content) if model_exists?
      end

      def migration_data
<<RUBY

  create_table(:#{rygsaek_prefix.pluralize}) do |t|
    t.string        :name, default: ''                                                              # how to identify the rygsaek (persistence provider)
    t.string        :provider,  default: 'Local'                                                    # name of the provider - local has special meaning
    t.text          :settings,  default: '{ local_root: "", endpoint: "#{Rails.root.join 'tmp'}"}'  # FIXME! you will loose uploads between deploys!!!!
    t.string        :file_permissions,  default: '0666'
    t.string        :directory_permissions, default: '0777'
    t.integer       :lock_version, default: 0                                                       # support Rails optimistic locking out-of-the-box
    t.timestamps
  end

  create_table(:#{rygsaek_prefix}_items) do |t|
    t.references    :#{rygsaek_prefix}, index: true
    t.string        :file_name, default: ''                                                         # how to identify the rygsaek (persistence provider)
    t.text          :meta_data, default: ''                                                         # use this field to add any kind of serialized data on a file - location, filters used, author, etc.
    t.integer       :lock_version, default: 0                                                       # support Rails optimistic locking out-of-the-box
    t.timestamps
  end

  create_table(:#{rygsaek_prefix}_item_links) do |t|
    t.references    :#{rygsaek_prefix}_item, index: true
    t.references    :#{rygsaek_prefix}_item_link, polymorphic: true                                           # model and id - eg.: Post and 23487
    t.string        :field_name                                                                     # attribute - eg.: picture
    t.integer       :file_version, default: 1                                                       # you may store multiple versions of that file
    t.integer       :lock_version, default: 0                                                       # support Rails optimistic locking out-of-the-box
    t.timestamps
  end

  add_index :#{rygsaek_prefix.pluralize},            :provider
  add_index :#{rygsaek_prefix}_items,       :file_name
  add_index :#{rygsaek_prefix}_item_links,  [:#{rygsaek_prefix}_item_link_id, :#{rygsaek_prefix}_item_link_type, :field_name, :file_version]

RUBY
      end

      def rygsaek_prefix
        "rygsaek"
      end

      def rails4?
        Rails.version.start_with? '4'
      end

      def postgresql?
        ActiveRecord::Base.connection.adapter_name.downcase == "postgresql"
      end
    end
  end
end
