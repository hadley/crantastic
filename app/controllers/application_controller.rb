# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0d745526fb23d6c4dd4ee297eaedd06c'

  protected
  def rescue_404
    rescue_action_in_public ActionController::UnknownAction.new
  end

  # Custom error processing after Hoptoad has been notified
  def rescue_action_in_public_without_hoptoad(exception)
    case exception
    when ::ActionController::UnknownAction, ::ActiveRecord::RecordNotFound then
      render :template => "static/error_404", :status => 404
    else
      render :template => "static/error_500", :status => 500,
                                              :locals => { :exception => exception }
    end
  end

  # Force local request to make sure rescue_action_in_public is triggered
  def local_request?
    false
  end

end
