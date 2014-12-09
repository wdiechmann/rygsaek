# Use this hook to configure rygsaek at startup
# Many of these configuration options can be set straight in your model.
Rygsaek.setup do |config|
  # The secret key used by Rygsaek. Rygsaek uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # api-calls setup for Rygsaek
<% if rails_4? -%>
  # config.secret_key = '<%= SecureRandom.hex(64) %>'
<% else -%>
  config.secret_key = '<%= SecureRandom.hex(64) %>'
<% end -%>

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'rygsaek/orm/<%= options[:orm] %>'

end
