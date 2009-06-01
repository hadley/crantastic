require File.dirname(__FILE__) + '/../spec_helper'

describe AuthorsController do

  it "should do a 404 for unknown ids" do
    get :show, :id => 9999
    response.status.should == "404 Not Found"
  end

end
