require File.dirname(__FILE__) + '/../spec_helper'

include AuthHelper

describe TagsController do

  def setup
    @tag = Tag.make
  end

  it "should render the index successfully" do
    get :index
    response.should be_success
    response.should render_template(:index)
  end

  it "should have a atom feed for tag activity" do
    get :show, :id => @tag.name, :format => "atom"
    response.status.should == "200 OK"
  end

end
