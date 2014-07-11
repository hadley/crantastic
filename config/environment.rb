# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.18' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
#require "lib/rails_extensions"

Rails::Initializer.run do |config|
  config.action_controller.session = {
    :key         => '_crantastic_session',
    :secret      => 'c4ac317cbe898d0d3f36b98a7817b1139897b106be50e928e96fe26b7b5699cf52cc9cc242ddbd888792c07d61c386b10653804e44e0d64e1cf99f5d9611cccb'
  }

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

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
end

ActionView::Base.field_error_proc = Proc.new do |html, instance|
  %{<div class="fieldWithErrors">#{html} <small class="error">&bull; #{[instance.error_message].flatten.first}</small></div>}.html_safe
end
