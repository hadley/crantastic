require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  setup do
    UserMailer.should_receive(:deliver_signup_notification)
    User.make
  end

  should_allow_values_for :email, "test@test.com", "john.doe@acme.co.uk"
  should_not_allow_values_for :email, "test", "test@test", "test@"
  should_validate_presence_of :email
  should_validate_presence_of :password

  it "should store activation time when activated" do
    u = User.new
    u.should_receive(:save).with(false)
    u.activated_at.should be_nil
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

  describe "Package voting" do

    setup do
      Package.make
    end

    it "should know if the user has voted for a package" do
      u = User.first
      pkg = Package.first

      u.voted_for?(pkg).should be_false
      PackageVote.create!(:package => pkg, :user => u)
      u.voted_for?(pkg).should be_true
    end

    it "should toggle votes for a package" do
      u = User.first
      pkg = Package.first

      u.toggle_vote(pkg).should be_true
      u.voted_for?(pkg).should be_true
      u.toggle_vote(pkg).should be_false
      u.voted_for?(pkg).should be_false
      u.toggle_vote(pkg).should be_true
      u.voted_for?(pkg).should be_true
    end

  end

end

describe UserMailer do

  before(:each) do
    UserMailer.should_receive(:deliver_signup_notification)
    @user = User.create(:login => "Helene", :email => "helene@helene.no",
                        :password => "1234", :password_confirmation => "1234")
  end

  describe "when sending an e-mail" do
    before(:each) do
      @email = UserMailer.create_signup_notification(@user)
    end

    it "should be sent to the user's email address" do
      @email.to.should == [@user.email]
    end

    it "should include an activation link" do
      # localhost for test environment, crantastic.org for production
      @email.body.match(" http://localhost:3000/activate/#{@user.activation_code} ").should_not be_nil
    end
  end

end
