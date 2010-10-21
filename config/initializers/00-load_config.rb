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
  ENV['TWITTER_ASECRET'] = private_config["TWITTER_ASECRET"]
  ENV['TWITTER_ATOKEN'] = private_config["TWITTER_ATOKEN"]
  ENV['TWITTER_PASSWORD'] = private_config["TWITTER_PASSWORD"]
  ENV['TWITTER_SECRET'] = private_config["TWITTER_SECRET"]
  ENV['TWITTER_TOKEN'] = private_config["TWITTER_TOKEN"]
end
