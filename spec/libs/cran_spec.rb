require File.join(File.dirname(__FILE__) + "/../../lib/cran.rb")

include CRAN

describe TaskView do

  before(:each) do
    @data = File.read(File.join(File.dirname(__FILE__) + "/data/Bayesian.ctv"))
  end

  it "should parse a ctv file" do
    tv = TaskView.new(@data)
    tv.name.should == "Bayesian"
    tv.topic.should == "Bayesian Inference"
    tv.version.should == "2009-06-11"
    tv.packagelist.size.should == 62
    tv.packagelist[0].should == "AdMit"
    tv.packagelist[1].should == "arm"
  end

end


describe TaskViews do

  before(:each) do
    @data = File.read(File.join(File.dirname(__FILE__) + "/data/index.html"))
  end

  it "should parse the view list" do
    views = TaskViews.new(@data)
    views.size.should == 24
    views[0].should == "Bayesian"
    views[23].should == "TimeSeries"
  end

end
