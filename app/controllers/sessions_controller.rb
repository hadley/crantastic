# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController

  def new
    if params[:layout] == "false"
      render :layout => false
    end
  end

  # Login or signup via RPX.
  # user_data returns e.g.
  # {:name=>'John Doe', :username => 'john', :email=>'john@doe.com',
  #  :identifier=>'blug.google.com/openid/dsdfsdfs3f3'}
  # When no user_data was found (invalid token supplied), data is empty.
  def rpx_token
    return(render :nothing => true, :status => :forbidden) if params[:token].blank?

    data = RPXNow.user_data(params[:token])

    if data.blank? # Login failed
      flash[:notice] = "Error"
      render :action => "new"
    end

    if data[:id] # User is already mapped to a primary key in our db
      self.current_user = User.find(data[:id])
    else
      # Dont find by email if the provided email was blank (which is the case
      # with logins from e.g. Twitter)
      user = (data[:email].blank?) ? nil : User.find_by_email(data[:email])

      # If the user wasn't already registered:
      if user.nil?
        user = User.new(:email => data[:email], :login => data[:username])
        if User.find_by_login(data[:username]) # Username already taken
          # Maybe not the most elegant way to do it, but it works for now
          user.login = ActiveSupport::SecureRandom.hex(5)
          flash[:notice] = "Your preferred username was not available. You have been " +
            "assigned a random username instead -- you can change it to " +
            "something else by editing your details."
        end
        User.transaction do
          user.save(false)
          user.activate(false)
        end
      end
      user.rpx.map(data[:identifier]) # Add PK mapping
      self.current_user = user
    end

    flash[:notice] = "Logged in successfully!" unless flash[:notice]
    redirect_back_or_default(user_path(self.current_user.id))
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if self.current_user.remember?
        self.current_user.remember_me
        cookies[:auth_token] = {
          :value => self.current_user.remember_token,
          :expires => self.current_user.remember_token_expires_at
        }
      end
      redirect_back_or_default(user_url(self.current_user))
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Invalid user name or password. Maybe you meant to <a href=\"/signup/\">sign up</a> instead?"
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end

end
