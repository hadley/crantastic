require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do

  it "should have a clear div helper" do
    helper.clear_div.should == %{<div class="clear"></div>}
  end

end
