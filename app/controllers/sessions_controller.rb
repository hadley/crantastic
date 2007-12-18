# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

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
      flash[:notice] = "Invalid user name or password.  Maybe you meant to <a href='/signup/'>sign up</a> instead?"
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
