require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/packages" do

  setup do
    ver = Version.make(:imports  => "graphics, stats, lattice, grid, SparseM, xtable",
                       :suggests => "optmatch, xtable")
    ver["imports"].split(", ").each { |pkg| Package.make(:name => pkg) }
    Package.make(:name => "optmatch")
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

  it "should show used packages" do
    response.should have_tag("p") do
      with_tag("strong", "Uses")
      with_tag("a", "lattice")
      with_tag("a", "SparseM")
      with_tag("a", "xtable")
      with_tag("em") do
        with_tag("a", "optmatch")
      end
      with_tag("em") do
        with_tag("a", "xtable")
      end
    end
  end

end
