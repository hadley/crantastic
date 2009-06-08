require File.dirname(__FILE__) + '/../spec_helper'

include AuthHelper

describe TagsController do

  it "should render the index successfully" do
    get :index
    response.should be_success
    response.should render_template(:index)
  end

end
