require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do

  it "should return status forbidden if accessing rpx_token without a token" do
    get "rpx_token"
    response.status.should == "403 Forbidden"
  end

  describe "RPX Now integration" do

    it "should create a user from RPXNow user data" do
      token = "asdfasdf1231231ij"
      data = { :name => "John Doe", :username => "john",
        :email => "john@domain.com", :identifier => "abc123" }
      RPXNow.should_receive(:user_data).with(token).and_return(data)

      rpx_proxy = RPXNow::UserProxy.new(1)
      rpx_proxy.should_receive(:map).with(data[:identifier])
      user = mock_model(User, {:id => 1, :login => data[:username],
                               :email => data[:email]})
      user.should_receive(:rpx).and_return(rpx_proxy)
      user.should_receive(:save).with(false)
      user.should_receive(:activate).with(false)
      User.should_receive(:new).and_return(user)

      get :rpx_token, :token => token

      response.flash[:notice].should == "Logged in successfully!"
      response.should be_redirect
      response.should redirect_to("http://test.host/users/1")
    end

  end

  describe "routes" do

    it "should have route for rpx now tokens" do
      route_for(:controller => "sessions", :action => "rpx_token").should == "/session/rpx_token"
    end

    it "should route to login and logout" do
      params_from(:get, "/login").should == { :controller => "sessions", :action => "new" }
      params_from(:get, "/logout").should == { :controller => "sessions", :action => "destroy" }
    end

  end

end
