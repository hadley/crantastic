require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do

  it "should return status forbidden if accessing rpx_token without a token" do
    get "rpx_token"
    response.status.should == "403 Forbidden"
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
