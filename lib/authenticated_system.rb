# Originally taken from restful_authentication, but many changes/additions has
# been made to make it suit our needs better.
module AuthenticatedSystem
  protected
  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  def logged_in?
    current_user != :false
  end

  # Accesses the current user from the session.  Set it to :false if login fails
  # so that future calls do not hit the database.
  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie || :false)
  end

  # Store the given user in the session.
  def current_user=(new_user)
    session[:user] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
    @current_user = new_user
  end

  # Check if the user is authorized
  #
  def authorized?
    logged_in?
  end

  # Filter method to enforce a login requirement.
  #
  # To require logins for all actions, use this in your controllers:
  #
  #   before_filter :login_required
  #
  # To require logins for specific actions, use this in your controllers:
  #
  #   before_filter :login_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required
  #
  def login_required
    logged_in? || access_denied
  end

  # Filter method to enforce an authorization requirement.
  def authorization_required
    authorized? || unauthorized
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

  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end

  # Called from #current_user.  First attempt to login by the user id stored in the session.
  def login_from_session
    self.current_user = User.find_by_id(session[:user]) if session[:user]
  end

  # Called from #current_user.  Now, attempt to login by basic authentication information.
  def login_from_basic_auth
    username, passwd = get_auth_data
    self.current_user = User.authenticate(username, passwd) if username && passwd
  end

  # Called from #current_user.  Finaly, attempt to login by an expiring token in the cookie.
  def login_from_cookie
    user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
    if user && user.remember_token?
      user.remember_me
      cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
      self.current_user = user
    end
  end

  private
  @@http_auth_headers = %w(Authorization HTTP_AUTHORIZATION X-HTTP_AUTHORIZATION X_HTTP_AUTHORIZATION REDIRECT_X_HTTP_AUTHORIZATION)

  # gets BASIC auth info
  def get_auth_data
    auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
    auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
    return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil]
  end
end
