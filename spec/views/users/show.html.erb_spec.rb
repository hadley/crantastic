require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/users" do

  setup do
    UserMailer.should_receive(:deliver_signup_notification)
    User.make
  end

  before(:each) do
    @user = User.first
    assigns[:user] = @user
  end

  it "should display a blank user profile" do
    render "users/show"
    response.should have_tag('p', "#{@user} hasn't written any reviews yet.")
    response.should have_tag('p', "#{@user} hasn't tagged any packages yet.")
  end

  it "should display the user's reviews" do
    ver = Version.make
    Review.make(:user => @user, :cached_rating => 3)
    Review.make(:user => @user, :cached_rating => nil)
    Review.make(:user => @user, :cached_rating => nil,
                :version => ver, :package => ver.package)

    render "users/show"
    response.should have_tag('p', "#{@user} has written 3 reviews:")
    response.should have_tag('ul') do
      with_tag('li', /gave .* a 3, and[\n ]* says/)
      with_tag('li', /did not rate .*, but[\n ]* says/)
      # Version should be displayed in parentheses when set
      with_tag('li', /did not rate .* \(#{ver}\).*, but[\n ]* says/)
    end
  end

  it "should display the user's taggings" do
    Tagging.make(:user => @user)
    render "users/show"
    response.should have_tag('h2', "Tags")
    response.should have_tag('p', "#{@user} has tagged 1 package:")
    response.should have_tag('ul') do
      with_tag('li', /with [a-zA-Z]*:/)
    end
  end

end
