require File.dirname(__FILE__) + '/../spec_helper'

describe PackagesController do

  integrate_views

  it "should render the index successfully" do
    get :index
    response.should render_template(:index)
  end

  it "should do a 301 for numerical package ids" do
    Package.should_receive(:find).with("1")
    get :show, :id => 1
    response.should be_redirect
  end

  it "should do a 404 for unknown packages" do
    get :show, :id => "blabla"
    response.status.should == "404 Not Found"
  end

end
