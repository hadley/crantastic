require File.dirname(__FILE__) + '/../spec_helper'

include AuthHelper

describe UsersController do

  integrate_views

  it "should render the index successfully" do
    get :index
    response.should render_template(:index)
  end

  it "should do a 404 for unknown users" do
    get :show, :id => 9999
    response.status.should == "404 Not Found"
  end

  it "should render the signup page successfully" do
    get :new
    response.should render_template(:new)
    response.should_not be_redirect
  end

  it "should require no user for the signup page" do
    login_as_user
    get :new
    response.should_not render_template
    response.should be_redirect
  end

  describe "#regenerate_api_key" do

    it "should require login" do
      post :regenerate_api_key
      response.should be_redirect
    end

  end

end
