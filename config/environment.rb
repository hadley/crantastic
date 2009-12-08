# Be sure to restart your server when you modify this file
require File.join(File.dirname(__FILE__), '/../lib/github_gem')

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
#require "lib/rails_extensions"

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
  config.gem 'authlogic',     :version => '= 2.1.3'
  config.gem 'couchrest',     :version => '= 0.33'
  config.gem 'gravtastic',    :version => '= 2.1.3'
  config.gem 'haml',          :version => '= 2.2.15'
  config.gem 'maruku',        :version => '= 0.6.0'
  config.gem 'rpx_now',       :version => '= 0.6.11'
  config.gem 'searchlogic',   :version => '= 2.3.9'
  config.gem 'twitter',       :version => '= 0.6.15'
  config.gem 'will_paginate', :version => '= 2.3.11'

  config.github_gem 'Chrononaut-aegis', :version => '= 1.2.0'
  config.github_gem 'giraffesoft-resource_controller', :version => '= 0.6.5'
  config.github_gem 'giraffesoft-timeline_fu', :version => '= 0.3.0'

  # Required, but do not attempt to load
  config.gem 'hpricot', :version => '= 0.8.2', :lib => false
  config.gem 'treetop', :version => '= 1.4.2', :lib => false

  config.gem 'treetop-dcf', :version => '= 0.2.0', :lib => false

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Activate observers that should always be running
  config.active_record.observers = :user_observer, :version_observer, :review_observer,
                                   :weekly_digest_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  config.after_initialize do # so rake gems:install works
    RPXNow.api_key = ENV['RPX_API_KEY']
  end
end

ActionView::Base.field_error_proc = Proc.new do |html, instance|
  %{<div class="fieldWithErrors">#{html} <small class="error">&bull; #{[instance.error_message].flatten.first}</small></div>}
end
