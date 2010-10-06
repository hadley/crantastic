class UsersController < ApplicationController

  before_filter :require_no_user, :only => [ :new, :create, :activate ]
  before_filter :require_user, :only => [:regenerate_api_key, :edit]

  load_and_authorize_resource

  def index
    @users = User.all
    @title = @users.length.to_s + " users"
  end

  def show
    @events = TimelineEvent.recent_for_user(object)
    set_atom_link(self, object)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      redirect_to thanks_url
    else
      render :action => :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @user.valid? # make sure any validation errors are highlighted
  end

  def update
    if object.update_attributes(params[:user])
      flash[:notice] = "Updated succesfully!"
      redirect_to user_url(object)
    else
      flash[:notice] = "The form did not pass validation."
      render :action => :edit
    end
  end

  def activate
    user = User.find_using_perishable_token(params[:activation_code], 1.week)

    unless user.nil? || user.active?
      user.activate
      user.deliver_activation_confirmation!
      UserSession.create(user)
      flash[:notice] = "Signup complete! You're now logged in and can start reviewing and tagging."
      redirect_to user_url(user)
    else
      flash[:notice] = "Incorrect activation url or already activated"
      redirect_to root_url
    end
  end

  def regenerate_api_key
    current_user.reset_single_access_token!
    flash[:notice] = "API Key regenerated"
    redirect_to user_url(current_user)
  end

  def thanks
    render
  end

  private

  def object
    @user ||= User.find(params[:id])
  end

end
