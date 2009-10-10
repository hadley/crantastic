HoptoadNotifier.configure do |config|
  config.api_key = ENV['HOPTOAD_API_KEY']

  config.environment_filters << "GMAIL"
  config.environment_filters << "RECAPTCHA_PRIVATE_KEY"
  config.environment_filters << "RECAPTCHA_PUBLIC_KEY"
  config.environment_filters << "TWITTER_SECRET"
  config.environment_filters << "TWITTER_TOKEN"
  config.environment_filters << "TWITTER_ASECRET"
  config.environment_filters << "TWITTER_ATOKEN"
end
