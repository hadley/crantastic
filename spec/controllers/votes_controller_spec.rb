require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VotesController do

  it "should do a 401 if the token for the create action is invalid" do
    post :create, :token => "invalid"
    response.status.should == "401 Unauthorized"
  end

  it "should accept valid tokens" do
    User.should_receive(:find_by_token).twice.and_return(mock_model(User))
    post :create, :token => "valid-token", :packages => ""
    response.status.should == "200 OK"
  end

end
