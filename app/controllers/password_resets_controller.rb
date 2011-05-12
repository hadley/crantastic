class PasswordResetsController < ApplicationController

  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]
  before_filter :require_no_user

  def new
    @title = "Reset your password"
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
        "Please check your email."
      redirect_to root_url
    else
      flash[:notice] = "No user was found with that email address"
      render :action => :new
    end
  end

  def edit
    @title = "Select a New Password"
  end

  def update
    # Activate user now unless already activated
    @user.activated_at = Time.now.utc unless @user.active?
    @user.tos = params[:user][:tos] if params[:user][:tos]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.valid? # force validation of attributes
    if @user.errors.on(:password).nil? # we only care about the password here,
      @user.save_without_validation    # some old accounts can have invalid usernames
      UserSession.create(@user)
      flash[:notice] = "Password successfully updated"
      redirect_to user_url(@user)
    else
      render :action => :edit
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account. " +
        "Note that the password reset link is only valid for 24 hours." +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to root_url
    end
  end

end
