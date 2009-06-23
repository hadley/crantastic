require File.dirname(__FILE__) + '/../spec_helper'

describe Review do

  should_validate_length_of :review, :minimum => 3
  should_validate_length_of :title, :minimum => 3

  setup do
    UserMailer.should_receive(:deliver_signup_notification)
    Package.make
    Version.make
    User.make
  end

  it "should strip title and review before validation" do
    r = Review.new(:title => " title \r\n")
    r.valid?
    r.title.should == "title"
  end

  it "should verify that the version belongs to the package" do
    pkg = Package.first
    review = Review.new(:package => pkg, :user => User.first,
                        :title => "Title", :review => "Lorem")
    review.version = Version.make(:package => pkg, :maintainer => Author.first)
    review.should be_valid
    review.version = Version.first
    review.should_not be_valid
    review.errors_on("version_id").should == ["Invalid version"]
  end

end
