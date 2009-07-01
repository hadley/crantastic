require File.dirname(__FILE__) + '/../spec_helper'

describe VersionsHelper do

  it "should give a message for versions that dont use any packages" do
    assigns[:version] = Version.make_unsaved(:imports => "", :suggests => "")
    helper.version_uses.should == "Does not use any package"
  end

end
