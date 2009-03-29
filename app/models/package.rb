# == Schema Information
#
# Table name: package
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#

class Package < ActiveRecord::Base
  has_many :versions, :order => "id DESC"
  has_many :reviews
  has_many :taggings

  default_scope :order => "LOWER(name)"
  # Used for the Package atom-feed:
  named_scope :recent, :order => "#{self.table_name}", :include => :versions,
                       :conditions => "#{self.table_name}.created_at IS NOT NULL"

  ## No. of packages to show per page.
  def self.per_page; 50; end

  ## Search On Name of Package.
  def self.search(search_term, search_results_page)
    search_term = '%' + String(search_term).downcase + '%'

    paginate :conditions => [ 'LOWER(name) LIKE ?', search_term],
             :include => {:versions => :maintainer},
             :page => search_results_page
  end

  def to_param
    name.gsub(".", "-")
  end

  def latest
    versions[0]
  end

  def google_url
    "http://www.google.com/search?q=" + CGI.escape("#{name} cran OR r-project -inurl:contrib -inurl:doc/packages -inurl:CRAN")
  end

  def scholar_url
    "http://scholar.google.com/scholar?q=" + CGI.escape(name)
  end

  def rhelp_url
   "http://finzi.psych.upenn.edu/cgi-bin/namazu.cgi" +
     "?idxname=Rhelp02a&idxname=Rhelp01&query=" + CGI.escape(name)
  end

  def rdevel_url
   "http://finzi.psych.upenn.edu/cgi-bin/namazu.cgi" +
     "?idxname=R-devel&query=" + CGI.escape(name)
  end

end
