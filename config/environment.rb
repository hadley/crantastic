# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.action_controller.session = {
    :session_key => '_crantastic_session',
    :secret      => 'c4ac317cbe898d0d3f36b98a7817b1139897b106be50e928e96fe26b7b5699cf52cc9cc242ddbd888792c07d61c386b10653804e44e0d64e1cf99f5d9611cccb'
  }

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'RedCloth'
  config.gem 'maruku'
  config.gem 'amatch'
  config.gem 'haml-edge', :lib => "haml"
  config.gem "sqlite3-ruby", :lib => "sqlite3"
  config.gem 'chrislloyd-gravtastic', :lib => "gravtastic", :version => '>= 2.1.2', :source => 'http://gems.github.com'
  config.gem 'Chrononaut-rpx_now', :lib => 'rpx_now', :version => '>= 0.5.6', :source => 'http://gems.github.com'
  config.gem 'mislav-will_paginate', :lib => "will_paginate", :source => 'http://gems.github.com'
  config.gem 'markbates-hoptoad_notifier', :lib => "hoptoad_notifier", :source => "http://gems.github.com"
  config.gem "giraffesoft-resource_controller", :lib => "resource_controller", :source => "http://gems.github.com"
  config.gem "giraffesoft-timeline_fu", :lib => "timeline_fu", :version => ">= 0.2.0", :source => "http://gems.github.com"

  # Required, but do not attempt to load
  config.gem 'treetop', :lib => false
  config.gem 'archive-tar-minitar', :lib => false
  config.gem 'Chrononaut-treetop-dcf', :version => '>= 0.1.2', :lib => false, :source => 'http://gems.github.com'
  config.gem 'hpricot', :lib => false

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  config.frameworks -= [ :active_resource ]

  # Activate observers that should always be running
  config.active_record.observers = :user_observer, :tagging_observer,
                                   :package_rating_observer, :version_observer,
                                   :review_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

ActionView::Base.field_error_proc = Proc.new do |html, instance|
  %{<div class="fieldWithErrors">#{html} <small class="error">&bull; #{[instance.error_message].flatten.first}</small></div>}
end
