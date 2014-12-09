require 'rygsaek/rails/routes'

module Rygsaek
  # class Engine < ::Rails::Engine
  #   config.rygsaek = Rygsaek
  #
  #   # Force routes to be loaded if we are doing any eager load.
  #   config.before_eager_load { |app| app.reload_routes! }
  #
  #   initializer "rygsaek.url_helpers" do
  #     Rygsaek.include_helpers(Rygsaek::Controllers)
  #   end
  #
  #   initializer "rygsaek.secret_key" do |app|
  #     if app.respond_to?(:secrets)
  #       Rygsaek.secret_key ||= app.secrets.secret_key_base
  #     elsif app.config.respond_to?(:secret_key_base)
  #       Rygsaek.secret_key ||= app.config.secret_key_base
  #     end
  #
  #     Rygsaek.token_generator ||=
  #       if secret_key = Rygsaek.secret_key
  #         Rygsaek::TokenGenerator.new(
  #           Rygsaek::CachingKeyGenerator.new(Rygsaek::KeyGenerator.new(secret_key))
  #         )
  #       end
  #   end
  #
  #   # initializer "rygsaek.fix_routes_proxy_missing_respond_to_bug" do
  #   #   # Deprecate: Remove once we move to Rails 4 only.
  #   #   ActionDispatch::Routing::RoutesProxy.class_eval do
  #   #     def respond_to?(method, include_private = false)
  #   #       super || routes.url_helpers.respond_to?(method)
  #   #     end
  #   #   end
  #   # end
  # end
end
