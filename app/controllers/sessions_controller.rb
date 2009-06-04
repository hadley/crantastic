# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController

  def new
  end

  # Login via RPX.
  # user_data returns e.g.
  # {:name=>'John Doe', :username => 'john', :email=>'john@doe.com',
  #  :identifier=>'blug.google.com/openid/dsdfsdfs3f3'}
  # When no user_data was found (invalid token supplied), data is empty.
  def rpx_token
    data = RPXNow.user_data(params[:token], ENV['RPX_API_KEY'])

    if data.blank? # Login failed
      flash[:notice] = "Error"
      render :action => "new"
      return
    end

    if data[:id] # User is already mapped to a primary key in our db
      self.current_user = User.find(data[:id])
    else
      self.current_user = User.find_by_email(data[:email]) ||
                          User.create!(:email => data[:email], :login => data[:username])

      self.current_user.add_identifier(data[:identifier])
    end

    flash[:notice] = "Logged in successfully"
    redirect_to user_url(self.current_user)
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_to request.referer
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Invalid user name or password.  Maybe you meant to <a href=\"/signup/\">sign up</a> instead?"
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to request.referer
  end
end
