# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  # replaces the value to all keys matching /password/i with "[FILTERED]"
  filter_parameter_logging :password

  helper :all # include all helpers, all the time

  include AuthenticatedSystem
  # Make these methods available as view helpers
  helper_method :current_user_session, :current_user, :logged_in?

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0d745526fb23d6c4dd4ee297eaedd06c'

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

  # Users created with RPX can in some cases be invalid, e.g. they may have
  # empty email addresses.
  def valid_login_required
    login_required
    if current_user && !current_user.valid?
      flash[:notice] = "Please update your profile with valid information."
      redirect_to edit_user_url(current_user)
    end
  end

  def check_permissions
    case params[:action]
    when 'edit' then
      current_user.may_edit!(object)
    when 'update' then
      current_user.may_edit!(object)
    when 'destroy' then
      current_user.may_destroy!(object)
    end
  rescue Aegis::PermissionError => e
    render :text => e.message, :status => :forbidden
  end

end
