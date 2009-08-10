class UsersController < ApplicationController

  before_filter :require_no_user, :only => [ :new, :create, :activate ]
  before_filter :require_user, :only => [ :edit, :update, :regenerate_api_key ]

  def index
    @users = User.all
    @title = @users.length.to_s + " users"
  end

  def show
    @user = User.find(params[:id])
    @events = TimelineEvent.recent_for_user(@user)
    respond_to do |format|
      format.html { set_atom_link(self, @user) }
      format.atom {}
    end
  rescue
    rescue_404
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
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    flash[:notice] = "Updated succesfully!"
    redirect_to user_url(@user)
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
    u = current_user
    u.reset_single_access_token
    u.save(false)
    flash[:notice] = "API Key regenerated"
    redirect_to user_url(current_user)
  end

  def thanks
    render
  end

end
