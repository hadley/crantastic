class UsersController < ApplicationController
  def new
    @user = User.new(params[:user])
  end
  
  def index
    @users = User.find :all
  end
  
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      # format.xml  { render :xml => @user }
    end
  end
    
  
  def create
    puts "Creating user"
    cookies.delete :auth_token

    @user = User.new(params[:user])
    @user.save!
    
    redirect_to thanks_path()
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def activate
    self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!  You're now logged in and can start reviewing and tagging."
    else 
      flash[:notice] = "Incorrect activation url"
    end
    redirect_back_or_default('/')
  end

end
