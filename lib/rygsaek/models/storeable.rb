# require 'rygsaek/hooks/activatable'
# require 'rygsaek/hooks/csrf_cleaner'
#
module Rygsaek
  module Models
    # Authenticatable module. Holds common settings for authentication.
    #
    # == Options
    #
    # Authenticatable adds the following options to devise_for:
    #
    #   * +authentication_keys+: parameters used for authentication. By default [:email].
    #
    #   * +http_authentication_key+: map the username passed via HTTP Auth to this parameter. Defaults to
    #     the first element in +authentication_keys+.
    #
    #   * +request_keys+: parameters from the request object used for authentication.
    #     By specifying a symbol (which should be a request method), it will automatically be
    #     passed to find_for_authentication method and considered in your model lookup.
    #
    #     For instance, if you set :request_keys to [:subdomain], :subdomain will be considered
    #     as key on authentication. This can also be a hash where the value is a boolean specifying
    #     if the value is required or not.
    #
    #   * +http_authenticatable+: if this model allows http authentication. By default false.
    #     It also accepts an array specifying the strategies that should allow http.
    #
    #   * +params_authenticatable+: if this model allows authentication through request params. By default true.
    #     It also accepts an array specifying the strategies that should allow params authentication.
    #
    #   * +skip_session_storage+: By default Devise will store the user in session.
    #     By default is set to skip_session_storage: [:http_auth].
    #
    # == active_for_authentication?
    #
    # After authenticating a user and in each request, Devise checks if your model is active by
    # calling model.active_for_authentication?. This method is overwritten by other devise modules. For instance,
    # :confirmable overwrites .active_for_authentication? to only return true if your model was confirmed.
    #
    # You overwrite this method yourself, but if you do, don't forget to call super:
    #
    #   def active_for_authentication?
    #     super && special_condition_is_valid?
    #   end
    #
    # Whenever active_for_authentication? returns false, Devise asks the reason why your model is inactive using
    # the inactive_message method. You can overwrite it as well:
    #
    #   def inactive_message
    #     special_condition_is_valid? ? super : :special_condition_is_not_valid
    #   end
    #
    module Storeable
      extend ActiveSupport::Concern
    end
  end
end
