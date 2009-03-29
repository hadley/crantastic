require File.dirname(__FILE__) + '/../spec_helper'

describe Package do
  it "should use dashes for params" do
    p = Package.new(:name => "bio.infer")
    p.to_param.should == "bio-infer"
  end
end
