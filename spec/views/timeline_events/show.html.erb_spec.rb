require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/timeline_events/index" do

  before(:each) do
    assigns[:timeline_events] = []
    render 'timeline_events/index'
  end

  it "should have a title" do
    response.should have_tag('h1', %r[Recent activity])
  end
end
