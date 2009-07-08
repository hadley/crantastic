require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VotesController do

  it "should do a 401 if the token for the create action is invalid" do
    post :create, :token => "invalid"
    response.status.should == "401 Unauthorized"
  end

  it "should accept valid tokens and set current_user " do
    user = mock_model(User)
    User.should_receive(:find_by_token).and_return(user)
    post :create, :token => "valid-token", :packages => ""
    response.status.should == "200 OK"
    controller.send(:current_user).should == user
  end

  it "should create new package votes" do
    ggplot = Package.make(:name => "ggplot")
    rjson  = Package.make(:name => "rjson")
    UserMailer.should_receive(:deliver_signup_notification)
    u = User.make
    u.generate_token
    post :create, :token => u.token, :packages => "ggplot,rjson"
    PackageVote.count.should == 2
    u.reload
    u.voted_for?(ggplot).should be_true
    u.voted_for?(rjson).should be_true
  end

end
