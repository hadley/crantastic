require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do

  it "should have a clear div helper" do
    helper.clear_div.should == %{<div class="clear"></div>}
  end

  it "should have a title helper that figures out if the title is plural or not" do
    helper.title.should == "It's crantastic!" # The default title

    assigns[:title] = "Welcome"
    helper.title.should == "Welcome. It's crantastic!"

    assigns[:title] = "Tags"
    helper.title.should == "Tags. They're crantastic!"
  end

end
