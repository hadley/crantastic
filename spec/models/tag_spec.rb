require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tag do

  should_allow_values_for :name, "Machine Learning", "Point-and-click",
                                 "AI", "NLP", :allow_nil => false
  should_not_allow_values_for :name, "", " AI", "asdf ", "sdf<h1>f", :allow_nil => false
  should_validate_length_of :name, :minimum => 2, :maximum => 100

  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :full_name => "value for full_name",
      :description => "value for description",
      :task_view => false
    }

    @tag = Tag.new
  end

  it "should create a new instance given valid attributes" do
    Tag.create!(@valid_attributes)
  end

  it "should equal a tag with the same name" do
    @tag.name = "awesome"
    new_tag = Tag.new(:name => "awesome")
    new_tag.should == @tag
  end

  it "should return its name when to_s is called" do
    @tag.name = "cool"
    @tag.to_s.should == "cool"
  end

end
