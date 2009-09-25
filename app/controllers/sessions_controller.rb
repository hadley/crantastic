# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController

  before_filter :require_no_user, :only => [ :new, :create, :rpx_token ]
  before_filter :require_user, :only => :destroy

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
      flash[:notice] = "Sorry, there was a problem with your account information. " +
        "Did you supply the correct credentials to your login provider? " +
        "(Please let us know at cranatic@gmail.com if you think the error is on our part.)"
      render :action => "new"
      return
    end

    if data[:id] # User is already mapped to a primary key in our db
      UserSession.create(User.find(data[:id]))
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
        user.from_rpx = true
        user.activate
      end
      user.rpx.map(data[:identifier]) # Add PK mapping
      UserSession.create(user)
    end
    flash[:notice] = "Logged in successfully!" unless flash[:notice]
    redirect_back_or_default(user_url(current_user))
  end

  def create
    session = UserSession.new(:login => params[:login],
                              :password => params[:password])
    if session.save
      if current_user.remember?
        session.remember_me = true
        session.save
      end
      redirect_back_or_default(user_url(current_user))
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Invalid user name or password. Maybe you meant to <a href=\"/signup/\">sign up</a> instead?"
      render :action => 'new'
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end

end
