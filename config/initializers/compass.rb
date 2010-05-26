# Only require Compass for development/testing environments. We simply use the
# compiled css files when in production and thus cuts down ~7mb on the Heroku
# slug size (yes, the compass gem is that large!).
unless RAILS_ENV == "production"
  require 'compass'
  # If you have any compass plugins, require them here.
  Compass.add_project_configuration(File.join(RAILS_ROOT, "config", "compass.config"))
  Compass.configuration.environment = RAILS_ENV.to_sym
  Compass.configure_sass_plugin!
end
