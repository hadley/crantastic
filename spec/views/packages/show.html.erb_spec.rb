require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/packages" do

  setup do
    Version.make
  end

  before(:each) do
    @pkg = Package.first
    assigns[:package] = @pkg
    assigns[:version] = @pkg.latest
    assigns[:tagging] = Tagging.new
    render 'packages/show'
  end

  it "should display the correct h1 title for a package page" do
    response.should have_tag('h1', "#{@pkg.name} (#{@pkg.latest.version})")
  end

  it "should display ratings" do
    response.should have_tag('h2', 'Ratings')
    response.should have_tag('span', /0\/5\s* \(0 votes\)/)
  end

end
