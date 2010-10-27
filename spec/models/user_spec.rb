# == Schema Information
#
# Table name: user
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)
#  email               :string(255)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  activated_at        :datetime
#  remember            :boolean(1)      default(FALSE), not null
#  homepage            :string(255)
#  profile             :text
#  profile_html        :text
#  single_access_token :string(255)     default(""), not null
#  role_name           :string(40)
#  perishable_token    :string(40)
#  persistence_token   :string(128)     default(""), not null
#  login_count         :integer(4)      default(0), not null
#  last_request_at     :datetime
#  last_login_at       :datetime
#  current_login_at    :datetime
#  last_login_ip       :string(255)
#  current_login_ip    :string(255)
#  tos                 :boolean(1)
#

require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  setup do
    User.make
    Version.make
  end

  it "accounts created with rpx should be valid even if they have blank password" do
    u = User.new(:login => "puppet", :email => "puppet@acme.com")
    u.should_not be_valid
    u.from_rpx = true
    u.should be_valid
  end

  it "accounts created with rpx should be valid even if they have blank emails" do
    u = User.new(:login => "puppet", :email => nil)
    u.should_not be_valid
    u.from_rpx = true
    u.should be_valid
  end

  it "accounts created with rpx should be valid even if they have weird usernames" do
    u = User.new(:login => "foo~|baz|")
    u.should_not be_valid
    u.from_rpx = true
    u.should be_valid
  end

  it "should not allow mismatched passwords" do
    u = User.new(:login => "puppet", :email => "puppet@acme.com",
                 :password => "321asd", :password_confirmation => "123asd")
    u.should_not be_valid
    u.errors.on(:password).should == "doesn't match confirmation"
  end

  it "should store activation time when activated" do
    u = User.new
    u.should_receive(:save!)
    u.should_not be_active
    u.activate
    u.should be_active
    u.activated_at.should be_kind_of(Time)
  end

  it "should cache the compiled profile markdown" do
    u = User.first
    markdown = "**Hello** _world_"
    u.profile = markdown
    u.save(false)
    u.reload
    u.profile_html.should == Maruku.new(markdown).to_html
  end

  it "should be identified as the author of a package" do
    u = User.first
    pkg = Package.first
    a = Author.first
    u.author_of?(pkg).should be_false
    u.author_identities << AuthorIdentity.new(:author => a)
    u.reload
    u.author_of?(pkg).should be_true
  end

  describe "Package voting" do

    it "should know if the user uses a package" do
      u = User.first
      pkg = Package.first

      u.uses?(pkg).should be_false
      PackageUser.create!(:package => pkg, :user => u)
      u.uses?(pkg).should be_true
    end

    it "should toggle votes for a package" do
      u = User.first
      pkg = Package.first

      u.toggle_usage(pkg).should be_true
      u.uses?(pkg).should be_true
      u.toggle_usage(pkg).should be_false
      u.uses?(pkg).should be_false
      u.toggle_usage(pkg).should be_true
      u.uses?(pkg).should be_true
    end

  end

end

describe UserMailer do

  before(:each) do
    @user = User.create(:login => "Helene", :email => "helene@helene.no",
                        :password => "1234", :password_confirmation => "1234",
                        :tos => true)
  end

  describe "when sending an e-mail" do
    before(:each) do
      @email = UserMailer.create_activation_instructions(@user)
    end

    it "should be sent to the user's email address" do
      @email.to.should == [@user.email]
    end

    it "should include an activation link" do
      # localhost for test environment, crantastic.org for production
      @email.body.match(" http://localhost:3000/activate/#{@user.perishable_token} ").should_not be_nil
    end
  end

end
