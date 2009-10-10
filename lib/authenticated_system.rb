# Originally taken from restful_authentication, but many changes/additions has
# been made to make it suit our needs better.
module AuthenticatedSystem

  protected
  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  def logged_in?
    current_user.not_nil?
  end

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
     @current_user ||= current_user_session && current_user_session.user
  end

  def login_required
    return access_denied unless logged_in?
    # Users created with RPX can in some cases be invalid, e.g. they may have
    # empty email addresses.
    unless current_user.valid? or (["edit", "update"].include?(request.params["action"]) &&
                                   request.params["controller"] == "users")
      flash[:notice] = "Please update your profile with valid information."
      redirect_to edit_user_url(current_user)
    end
  end
  alias :require_user :login_required

  def admin_required
    (logged_in? && current_user.role.name == :administrator) || access_denied
  end

  def require_no_user
    if logged_in?
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_url
    end
  end

  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the user is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    flash[:notice] = "You need to log in to access this page.  Don't have a login?  Then <a href='/users/new/'>sign up now</a>!"
    respond_to do |accepts|
      accepts.html do
        # FIXME: ugly hack, neccessary because of the JS stuff in packages/show.
        # Find a cleaner way.
        if request.method == :post && request.path =~ /\/taggings$/
          store_location(package_url(params[:package_id]))
        else
          store_location
        end
        redirect_to(login_url)
      end
      accepts.xml do
        headers["Status"]           = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text => "Could't authenticate you", :status => '401 Unauthorized'
      end
    end
    false
  end

  def unauthorized
    flash[:notice] = "You are not authorised to see that page."

    respond_to do |accepts|
      accepts.html do
        redirect_back_or_default("/")
      end
      accepts.xml do
        headers["Status"]           = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text => "Unauthorized", :status => '401 Unauthorized'
      end
    end
    false
  end

  # Store the URI of the current request in the session, unless already logged in.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location(location = request.request_uri)
    session[:return_post_params] = params if request.method == :post
    session[:return_to] = location unless logged_in?
  end

  def unset_location
    session[:return_to] = nil
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back_or_default(default)
    return_params = session[:return_post_params]
    session[:return_post_params] = nil
    if return_params
      redirect_post(return_params)
    else
      redirect_to(params[:return_to] || session[:return_to] || default)
    end
    session[:return_to] = nil
  end

end
