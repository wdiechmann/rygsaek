require "active_support/core_ext/object/try"
require "active_support/core_ext/hash/slice"

module ActionDispatch::Routing
  class RouteSet #:nodoc:
    # Ensure Rygsaek modules are included only after loading routes, because we
    # need rygsaek_on mappings already declared to create filters and helpers.
    def finalize_with_rygsaek!
      result = finalize_without_rygsaek!

      @rygsaek_finalized ||= begin
        if Rygsaek.router_name.nil? && defined?(@rygsaek_finalized) && self != Rails.application.try(:routes)
          warn "[RYGSAEK] We have detected that you are using rygsaek_on inside engine routes. " \
            "In this case, you probably want to set Rygsaek.router_name = MOUNT_POINT, where "   \
            "MOUNT_POINT is a symbol representing where this engine will be mounted at. For "   \
            "now Rygsaek will default the mount point to :main_app. You can explicitly set it"   \
            " to :main_app as well in case you want to keep the current behavior."
        end

        Rygsaek.regenerate_helpers!
        true
      end

      result
    end
    alias_method_chain :finalize!, :rygsaek
  end

  class Mapper
    # Some basic good ideas about routing
    #
    #
    # resources :studentregs, :subjects, :teacherregs, :posts, :studentregs
    # pages = %w(home about contactus help)
    # for page in pages do
    #      get page, to: "pages##{page}"
    # end
    #
    # resources :posts do
    #    resources :comments, :only => [:create]
    #    member { post :vote }
    # end
    #
    # devise_for :admin_users, ActiveAdmin::Devise.config
    # ActiveAdmin.routes(self)
    # get 'tags/:tag', to: 'posts#index', as: :tag
    #
    #
    # devise_for :cubeprincipals
    # devise_for :cubestudents
    # devise_for :cubeteachers
    #
    # root to: 'pages#home'
    #
    


    # Includes rygsaek_on method for routes. This method is responsible to
    # generate all needed routes for rygsaek, based on what modules you have
    # defined in your model.
    #
    # ==== Examples
    #
    # Let's say you have an User model configured to use authenticatable,
    # confirmable and recoverable modules. After creating this inside your routes:
    #
    #   rygsaek_on :jobbers
    #
    # This method is going to look inside your User model and create the
    # needed (RESTful) routes:
    #
    #   jobber_enclosures_path      GET     /jobbers/:id/enclosures(.:format)                   rygsaek/enclosures#index
    #                               POST    /jobbers/:id/enclosures(.:format)                   rygsaek/enclosures#create
    #   new_jobber_enclosure_path   GET     /jobbers/:id/enclosures/new(.:format)               rygsaek/enclosures#new
    #   edit_jobber_enclosure_path  GET     /jobbers/:id/enclosures/:id/edit(.:format)          rygsaek/enclosures#edit
    #   jobber_enclosure_path       GET     /jobbers/:id/enclosures/:id(.:format)               rygsaek/enclosures#show
    #                               PATCH   /jobbers/:id/enclosures/:id(.:format)               rygsaek/enclosures#update
    #                               PUT     /jobbers/:id/enclosures/:id(.:format)               rygsaek/enclosures#update
    #                               DELETE  /jobbers/:id/enclosures/:id(.:format)               rygsaek/enclosures#destroy
    #
    # ==== Routes integration
    #
    # +rygsaek_on+ is meant to play nicely with other routes methods. For example,
    # by calling +rygsaek_on+ inside a namespace, it automatically nests your rygsaek
    # controllers:
    #
    #     namespace :admin do
    #       rygsaek_on :documents
    #     end
    #
    # The snippet above will use publisher/sessions controller instead of rygsaek/sessions
    # controller. You can revert this change or configure it directly by passing the :module
    # option described below to +rygsaek_on+.
    #
    # Also note that when you use a namespace it will affect all the helpers and methods
    # for controllers and views. For example, using the above setup you'll end with
    # following methods: current_publisher_account, authenticate_publisher_account!,
    # publisher_account_signed_in, etc.
    #
    # The only aspect not affect by the router configuration is the model name. The
    # model name can be explicitly set via the :class_name option.
    #
    # ==== Options
    #
    # You can configure your routes with some options:
    #
    #  * class_name: setup a different class to be looked up by rygsaek, if it cannot be
    #    properly found by the route name.
    #
    #      rygsaek_on :users, class_name: 'Account'
    #
    #  * path: allows you to setup path name that will be used, as rails routes does.
    #    The following route configuration would setup your route as /accounts instead of /users:
    #
    #      rygsaek_on :users, path: 'accounts'
    #
    #  * singular: setup the singular name for the given resource. This is used as the instance variable
    #    name in controller, as the name in routes and the scope given to warden.
    #
    #      rygsaek_on :users, singular: :user
    #
    #  * path_names: configure different path names to overwrite defaults :sign_in, :sign_out, :sign_up,
    #    :password, :confirmation, :unlock.
    #
    #      rygsaek_on :users, path_names: {
    #        sign_in: 'login', sign_out: 'logout',
    #        password: 'secret', confirmation: 'verification',
    #        registration: 'register', edit: 'edit/profile'
    #      }
    #
    #  * controllers: the controller which should be used. All routes by default points to Devise controllers.
    #    However, if you want them to point to custom controller, you should do:
    #
    #      rygsaek_on :users, controllers: { sessions: "users/sessions" }
    #
    #  * failure_app: a rack app which is invoked whenever there is a failure. Strings representing a given
    #    are also allowed as parameter.
    #
    #  * sign_out_via: the HTTP method(s) accepted for the :sign_out action (default: :get),
    #    if you wish to restrict this to accept only :post or :delete requests you should do:
    #
    #      rygsaek_on :users, sign_out_via: [ :post, :delete ]
    #
    #    You need to make sure that your sign_out controls trigger a request with a matching HTTP method.
    #
    #  * module: the namespace to find controllers (default: "rygsaek", thus
    #    accessing rygsaek/sessions, rygsaek/registrations, and so on). If you want
    #    to namespace all at once, use module:
    #
    #      rygsaek_on :users, module: "users"
    #
    #  * skip: tell which controller you want to skip routes from being created.
    #    It accepts :all as an option, meaning it will not generate any route at all:
    #
    #      rygsaek_on :users, skip: :sessions
    #
    #  * only: the opposite of :skip, tell which controllers only to generate routes to:
    #
    #      rygsaek_on :users, only: :sessions
    #
    #  * skip_helpers: skip generating Devise url helpers like new_session_path(@user).
    #    This is useful to avoid conflicts with previous routes and is false by default.
    #    It accepts true as option, meaning it will skip all the helpers for the controllers
    #    given in :skip but it also accepts specific helpers to be skipped:
    #
    #      rygsaek_on :users, skip: [:registrations, :confirmations], skip_helpers: true
    #      rygsaek_on :users, skip_helpers: [:registrations, :confirmations]
    #
    #  * format: include "(.:format)" in the generated routes? true by default, set to false to disable:
    #
    #      rygsaek_on :users, format: false
    #
    #  * constraints: works the same as Rails' constraints
    #
    #  * defaults: works the same as Rails' defaults
    #
    #  * router_name: allows application level router name to be overwritten for the current scope
    #
    # ==== Scoping
    #
    # Following Rails 3 routes DSL, you can nest rygsaek_on calls inside a scope:
    #
    #   scope "/my" do
    #     rygsaek_on :users
    #   end
    #
    # However, since Devise uses the request path to retrieve the current user,
    # this has one caveat: If you are using a dynamic segment, like so ...
    #
    #   scope ":locale" do
    #     rygsaek_on :users
    #   end
    #
    # you are required to configure default_url_options in your
    # ApplicationController class, so Devise can pick it:
    #
    #   class ApplicationController < ActionController::Base
    #     def self.default_url_options
    #       { locale: I18n.locale }
    #     end
    #   end
    #
    # ==== Adding custom actions to override controllers
    #
    # You can pass a block to rygsaek_on that will add any routes defined in the block to Devise's
    # list of known actions.  This is important if you add a custom action to a controller that
    # overrides an out of the box Devise controller.
    # For example:
    #
    #    class RegistrationsController < Devise::RegistrationsController
    #      def update
    #         # do something different here
    #      end
    #
    #      def deactivate
    #        # not a standard action
    #        # deactivate code here
    #      end
    #    end
    #
    # In order to get Devise to recognize the deactivate action, your rygsaek_scope entry should look like this:
    #
    #     rygsaek_scope :owner do
    #       post "deactivate", to: "registrations#deactivate", as: "deactivate_registration"
    #     end
    #
    def rygsaek_on(*resources)
      @rygsaek_finalized = false
      raise_no_secret_key unless Rygsaek.secret_key
      options = resources.extract_options!
#
#       options[:as]          ||= @scope[:as]     if @scope[:as].present?
#       options[:module]      ||= @scope[:module] if @scope[:module].present?
#       options[:path_prefix] ||= @scope[:path]   if @scope[:path].present?
#       options[:path_names]    = (@scope[:path_names] || {}).merge(options[:path_names] || {})
#       options[:constraints]   = (@scope[:constraints] || {}).merge(options[:constraints] || {})
#       options[:defaults]      = (@scope[:defaults] || {}).merge(options[:defaults] || {})
#       options[:options]       = @scope[:options] || {}
#       options[:options][:format] = false if options[:format] == false
#
      resources.map!(&:to_sym)

      resources.each do |resource|
        mapping = Rygsaek.add_mapping(resource, options)

        begin
          raise_no_rygsaek_method_error!(mapping.class_name) unless mapping.to.respond_to?(:rygsaek)
        rescue NameError => e
          raise unless mapping.class_name == resource.to_s.classify
          warn "[WARNING] You provided rygsaek_on #{resource.inspect} but there is " \
            "no model #{mapping.class_name} defined in your application"
          next
        rescue NoMethodError => e
          raise unless e.message.include?("undefined method `rygsaek'")
          raise_no_rygsaek_method_error!(mapping.class_name)
        end

        routes = mapping.used_routes

        rygsaek_scope mapping.name do
          with_rygsaek_exclusive_scope mapping.fullpath, mapping.name, options do
            routes.each { |mod| send("rygsaek_#{mod}", mapping, mapping.controllers) }
          end
        end
      end
    end

    # Sets the rygsaek scope to be used in the controller. If you have custom routes,
    # you are required to call this method (also aliased as :as) in order to specify
    # to which controller it is targetted.
    #
    #   as :employee do
    #     get "selfie", to: "employees/:id/selfie"
    #   end
    #
    # Notice you cannot have two scopes mapping to the same URL. And remember, if
    # you try to access a rygsaek controller without specifying a scope, it will
    # raise ActionNotFound error.
    #
    # Also be aware of that 'rygsaek_scope' and 'as' use the singular form of the
    # noun where other rygsaek route commands expect the plural form. This would be a
    # good and working example.
    #
    #  rygsaek_scope :post do
    #    get "/some/route" => "some_rygsaek_controller"
    #  end
    #  rygsaek_on :posts
    #
    # Notice and be aware of the differences above between :user and :users
    def rygsaek_scope(scope)
      constraint = lambda do |request|
        request.env["rygsaek.mapping"] = Rygsaek.mappings[scope]
        true
      end

      constraints(constraint) do
        yield
      end
    end
    alias :as :rygsaek_scope

    protected

      RYGSAEK_SCOPE_KEYS = [:as, :path, :module, :constraints, :defaults, :options]

      def with_rygsaek_exclusive_scope(new_path, new_as, options) #:nodoc:
        old = {}
        RYGSAEK_SCOPE_KEYS.each { |k| old[k] = @scope[k] }

        new = { as: new_as, path: new_path, module: nil }
        new.merge!(options.slice(:constraints, :defaults, :options))

        @scope.merge!(new)
        yield
      ensure
        @scope.merge!(old)
      end

      def raise_no_secret_key #:nodoc:
        raise <<-ERROR
Rygsaek.secret_key was not set. Please add the following to your Rygsaek initializer:

  config.secret_key = '#{SecureRandom.hex(64)}'

Please ensure you restarted your application after installing Rygsaek or setting the key.
ERROR
      end

      def raise_no_rygsaek_method_error!(klass) #:nodoc:
        raise "#{klass} does not respond to 'rygsaek' method. This usually means you haven't " \
          "loaded your ORM file or it's being loaded too late. To fix it, be sure to require 'rygsaek/orm/YOUR_ORM' " \
          "inside 'config/initializers/rygsaek.rb' or before your application definition in 'config/application.rb'"
      end
#   end
end
