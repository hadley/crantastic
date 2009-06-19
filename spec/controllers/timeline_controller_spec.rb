require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TimelineController do

  it "should assign timeline events" do
    stub = stub_model(TimelineEvent)
    User.should_receive(:find).and_return(stub_model(User))
    TimelineEvent.should_receive(:recent_for_user).and_return([stub])
    get :show, :user_id => 74
    assigns(:events).should == [stub]
  end

end
