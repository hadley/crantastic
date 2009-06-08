require File.dirname(__FILE__) + '/../spec_helper'

include AuthHelper

describe TaggingsController do

  it "should redirect to login when attempting to tag without logging in first" do
    get :new
    response.should be_redirect
    response.flash[:notice].should =~ /You need to log in to access this page/
  end

end
