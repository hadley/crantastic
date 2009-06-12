require File.dirname(__FILE__) + '/../spec_helper'

describe Review do

  should_validate_presence_of :package_id
  should_validate_presence_of :user_id
  should_validate_length_of :review, :minimum => 3
  should_validate_length_of :title, :minimum => 3

  it "should strip title and review before validation" do
    r = Review.new(:title => " title \r\n")
    r.valid?
    r.title.should == "title"
  end

  it "should only allow valid values for rating (1-5)" do
    r = Review.new(:rating => 0)
    r.should have(1).error_on(:rating)
    1.upto(5) do |i|
      r.rating = i
      r.should have(0).errors_on(:rating)
    end
    r.rating = 6
    r.should have(1).error_on(:rating)
  end

end
