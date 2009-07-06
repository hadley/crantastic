# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

# Redirects www.domain/* to domain/*
class CanonicalizeUrl
  def self.call(env)
    if env["HTTP_HOST"] =~ /^www\./
      [301, {'Location' => "http://#{APP_CONFIG[:site_domain]}#{env['PATH_INFO']}"}, 'Redirect']
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end
