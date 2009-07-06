# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

# Drop-in replacement for the LiveValidations controller that ships with
# live-validations.
class ValidationPoller

  def self.call(env)
    if env["PATH_INFO"] =~ /^\/live_validations\/uniqueness/
      params = HashWithIndifferentAccess.new(Rack::Request.new(env).params)
      responder = LiveValidations.current_adapter.validation_responses[:uniqueness]

      [200, {"Content-Type" => "text/html"}, [responder.respond(params).to_s]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end

end
