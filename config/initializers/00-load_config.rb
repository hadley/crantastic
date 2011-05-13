# Load global app configuration
APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/settings.yml")[Rails.env].symbolize_keys

# Load private configuration (API keys etc)
# If private.yml isn't available, we're falling back to using ENV variables
private_config = if File.exists?("#{RAILS_ROOT}/config/private.yml")
                   YAML.load_file("#{RAILS_ROOT}/config/private.yml")
                 end

unless private_config.nil?
  ENV["GMAIL"] = private_config["GMAIL"]
  ENV["HOPTOAD_API_KEY"] = private_config["HOPTOAD_API_KEY"]
  ENV["RPX_API_KEY"] = private_config["RPX_API_KEY"]
  ENV['BITLY_API_KEY'] = private_config["BITLY_API_KEY"]
  ENV['BITLY_USERNAME'] = private_config["BITLY_USERNAME"]
  ENV['CRANTASTIC_PASSWORD'] = private_config["CRANTASTIC_PASSWORD"]
  ENV['RECAPTCHA_PRIVATE_KEY'] = private_config["RECAPTCHA_PRIVATE_KEY"]
  ENV['RECAPTCHA_PUBLIC_KEY'] = private_config["RECAPTCHA_PUBLIC_KEY"]
  ENV['TWITTER_OAUTH_TOKEN_SECRET'] = private_config["TWITTER_OAUTH_TOKEN_SECRET"]
  ENV['TWITTER_OAUTH_TOKEN'] = private_config["TWITTER_OAUTH_TOKEN"]
  ENV['TWITTER_CONSUMER_KEY'] = private_config["TWITTER_CONSUMER_KEY"]
  ENV['TWITTER_CONSUMER_SECRET'] = private_config["TWITTER_CONSUMER_SECRET"]
end
