class RygsaekCreate<%= table_name.camelize %> < ActiveRecord::Migration
  def change
    <%= migration_data -%>
  end
end
