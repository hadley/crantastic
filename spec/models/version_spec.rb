require File.dirname(__FILE__) + '/../spec_helper'

describe Version do

  setup do
    Version.make
  end

  should_allow_values_for :title, "Title", "", :allow_nil => true
  should_allow_values_for :url, "http://foo.bar", "", :allow_nil => true

  should_validate_presence_of :version

  should_validate_length_of :name, :minimum => 2, :maximum => 255
  should_validate_length_of :version, :minimum => 1, :maximum => 25
  should_validate_length_of :title, :minimum => 0, :maximum => 255
  should_validate_length_of :url, :minimum => 0, :maximum => 255

  it "should set itself as the package's latest version when created'" do
    ver1 = Version.first

    pkg = Package.first
    pkg.latest_version.should == ver1

    ver2 = Version.create!(:package => pkg, :name => pkg.name, :version => "2.0")
    pkg.latest_version.should == ver2
  end

  it "should use its version as a string representation" do
    Version.first.to_s.should == Version.first.version
  end

  it "should know its cran url" do
    Version.first.cran_url.should ==
      "http://cran.r-project.org/web/packages/#{Version.first.name}"
  end

  it "should produce a list of urls" do
    ver = Version.first
    ver.url = "http://foo, http://bar"

    ver.urls.should == ["http://foo", "http://bar",
                        "http://cran.r-project.org/web/packages/#{ver.name}"]
  end

end
