# == Schema Information
#
# Table name: version
#
#  id                     :integer(4)      not null, primary key
#  package_id             :integer(4)
#  name                   :string(255)
#  title                  :string(255)
#  description            :text
#  license                :text
#  version                :string(255)
#  depends                :text
#  suggests               :text
#  author                 :text
#  url                    :string(255)
#  date                   :date
#  readme                 :text
#  changelog              :text
#  news                   :text
#  diff                   :text
#  created_at             :datetime
#  updated_at             :datetime
#  maintainer_id          :integer(4)
#  imports                :text
#  enhances               :text
#  priority               :string(255)
#  publicized_or_packaged :datetime
#  version_changes        :text
#

require File.dirname(__FILE__) + '/../spec_helper'

describe Version do

  setup do
    Version.make
    Author.make
    User.make(:id => 146)
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

    ver2 = Version.create!(:package => pkg, :name => pkg.name, :version => "2.0",
                           :maintainer => Author.first)
    pkg.latest_version.should == ver2
  end

  it "should know its previous version" do
    pkg = Package.first
    ver1 = pkg.versions.first
    ver2 = Version.create!(:package => pkg, :name => pkg.name, :version => "3.0",
                           :maintainer => Author.first)

    ver2.previous.should == ver1
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

  it "should handle priority taggings" do
    pkg = Package.make
    pkg.tags.type("Priority").size.should == 0

    Version.make(:package => pkg,
                 :priority => "",
                 :maintainer => Author.first)
    pkg.tags.type("Priority").size.should == 0

    Version.make(:package => pkg,
                 :version => "2.5",
                 :priority => "recommended",
                 :maintainer => Author.first)

    pkg.tags.type("Priority").size.should == 1
    pkg.tags.type("Priority").first.name.should == "Recommended"

    Version.make(:package => pkg,
                 :version => "3.0",
                 :priority => "base, recommended",
                 :maintainer => Author.first)
    pkg.tags.type("Priority").size.should == 2

    Version.make(:package => pkg,
                 :version => "3.5",
                 :priority => "recommended",
                 :maintainer => Author.first)

    pkg.tags.type("Priority").size.should == 1
    pkg.tags.type("Priority").first.name.should == "Recommended"

    # New version w/o priority, old priority tagging should be removed
    Version.make(:package => pkg,
                 :version => "4.0",
                 :priority => "",
                 :maintainer => Author.first)
    pkg.tags.type("Priority").size.should == 0
  end

  it "should prefer publication/package date over the regular date field" do
    v = Version.make(:date => "2008-05-05",
                     :maintainer => Author.first)
    v.date.to_s.should == "2008-05-05"
    v.update_attribute(:publicized_or_packaged, "2009-12-12")
    v.date.to_date.to_s.should == "2009-12-12"
  end

  it "should parse the author list" do
    a1 = Author.make(:name => "Ian Rush")
    a2 = Author.make(:name => "Rob Fowler")
    v = Version.make_unsaved(:author => "Ian Rush, Rob Fowler")
    v.parse_authors.should == [a1, a2]

    v.author = nil
    v.parse_authors.should == []
  end

end
