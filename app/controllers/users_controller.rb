class UsersController < ApplicationController

  resource_controller

  create.before { cookies.delete :auth_token }
  create.wants.html { redirect_to thanks_path }
  show.failure.wants.html { rescue_404 }
  show.before { @events = TimelineEvent.recent_for_user(@user) }
  show.wants.html { set_atom_link(self, @user) }
  show.wants.atom {}
  index.wants.html { @title = @users.length.to_s + " users" }

  def activate
    self.current_user = User.find_by_activation_code(params[:activation_code])

    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete! You're now logged in and can start reviewing and tagging."
    else
      flash[:notice] = "Incorrect activation url"
    end
    redirect_back_or_default('/')
  end

end
