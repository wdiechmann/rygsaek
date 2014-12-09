# Use this hook to configure rygsaek at startup
# Many of these configuration options can be set straight in your model.
Rygsaek.setup do |config|
  # The secret key used by Rygsaek. Rygsaek uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # api-calls setup for Rygsaek
  # config.secret_key = '3d75ece6aac192ebf59d203faded20f0382ac871a6edceb559f012ddaddce70b621d9a829edfade235e620da9558d34f7b90c2e8a41806ae5b3027fcecc5b832'

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'rygsaek/orm/false'

end
