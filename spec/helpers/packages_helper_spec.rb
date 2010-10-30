require File.dirname(__FILE__) + '/../spec_helper'

describe PackagesHelper do

  def setup
    @pkg = Package.new
  end

  describe "rating helper" do

    it "should return blank if no ratings" do
      @pkg.stub(:rating_count).and_return(0)
      helper.rating(@pkg).should == ""
    end

    it "should return the avg if there are ratings" do
      @pkg.stub(:rating_count).and_return(2)
      @pkg.stub(:average_rating).and_return(4)
      helper.rating(@pkg).should == "4.0/5"
    end

  end

end
