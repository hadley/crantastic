# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  include AuthenticatedSystem
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0d745526fb23d6c4dd4ee297eaedd06c'

  before_filter :unset_location_unless_stored_in_filter_chain
  before_filter :correct_accept_headers

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
      @exception = exception
      render :template => "static/error_500", :status => 500
    end
  end

  # Force local request to make sure rescue_action_in_public is triggered
  def local_request?
    false
  end

  ###
  # This allows us to easily redirect back to stored locations:
  # Set :store_location as a before_filter in controllers that should
  # store locations (e.g. PackagesController). Note that AuthenticatedSystem
  # automatically stores the url the user tried to access before encountering
  # :login_required, so that's already taken care of. This filter unsets
  # the currently stored location (if any) when the filter chain does not
  # include :store_location, or if the user is in the Sessions controller.
  def unset_location_unless_stored_in_filter_chain
    unless self.class.filter_chain.map(&:method).include?(:store_location) or
        self.class == SessionsController
      unset_location
    end
  end

  # Adapted this from http://codetunes.com/2008/12/08/rails-ajax-and-jquery/
  # Necessary for IE, Safari, and Opera. There probably is a more elegant way to
  # fix this, though..
  def correct_accept_headers
    if request.xhr?
      request.accepts.sort!{ |x, y| y.to_s == 'text/javascript' ? 1 : -1 }
    end
  end

  # Set an atom link for the layout header
  def set_atom_link(caller, obj)
    caller.instance_variable_set(:@atom, {
      :url => polymorphic_url(obj, :format => :atom),
      :title => "Latest activity for #{obj}"
    })
  end

  def login_or_token_required
    (request.post? && params.has_key?(:token)) ? token_required : login_required
  end

  def token_required
    if User.find_by_token(params[:token], :conditions => "token IS NOT NULL").nil?
      render :nothing => true, :status => :unauthorized
      return false
    end
  end

end
