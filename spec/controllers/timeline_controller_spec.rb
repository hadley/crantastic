require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TimelineController do

  it "should assign timeline events" do
    stub = stub_model(TimelineEvent)
    TimelineEvent.should_receive(:recent).and_return([stub])
    get :show
    assigns(:timeline_events).should == [stub]
  end

end
