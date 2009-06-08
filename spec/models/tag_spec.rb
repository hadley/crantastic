require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tag do

  should_allow_values_for :name, "Machine Learning", "AI", "NLP", :allow_nil => false
  should_not_allow_values_for :name, "", " AI", "asdf  ", :allow_nil => false
  should_validate_length_of :name, :minimum => 2, :maximum => 100

  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :full_name => "value for full_name",
      :description => "value for description",
      :task_view => false
    }
  end

  it "should create a new instance given valid attributes" do
    Tag.create!(@valid_attributes)
  end

end
