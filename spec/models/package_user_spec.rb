# == Schema Information
#
# Table name: package_user
#
#  id         :integer(4)      not null, primary key
#  package_id :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  active     :boolean(1)      default(TRUE), not null
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PackageUser do

  setup do
    Package.make
    User.make
  end

  it "should have a counter cache for the number of votes" do
    p = Package.first
    p.package_users_count.should == 0
    p.package_users << PackageUser.new(:user => User.first)
    p.reload
    p.package_users_count.should == 1
  end

end
