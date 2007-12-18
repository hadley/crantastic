class UsersController < ApplicationController
  def new
    @user = User.new(params[:user])
  end

  def create
    puts "Creating user"
    cookies.delete :auth_token

    @user = User.new(params[:user])
    @user.save!
    
    self.current_user = @user
    redirect_back_or_default('/')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def activate
    self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
    else 
      flash[:notice] = "Incorrect activation url"
    end
    redirect_back_or_default('/')
  end

end
