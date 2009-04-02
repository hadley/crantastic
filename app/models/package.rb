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
  include NoFuzz
  fuzzy :name

  has_many :versions, :order => "id DESC"
  has_many :reviews
  has_many :taggings

  default_scope :order => "LOWER(package.name)"
  # Used for the Package atom-feed:
  named_scope :recent, :order => "#{self.table_name}", :include => :versions,
                       :conditions => "#{self.table_name}.created_at IS NOT NULL"

  ## No. of packages to show per page.
  def self.per_page; 50; end

  ## Search On Name of Package.
  def self.paginating_search(q, search_results_page)
    q.strip.downcase!

    if q.ends_with? '~' # fuzzy search
      # TODO It's kinda bad to do two database hits here, I think it can be resolved
      # by using paginate's :finder argument and creating a new method that
      # calls out to fuzzy_find.
      ids = Package.fuzzy_find(q[0...-1]).collect { |i| i.id }
      paginate ids,
               :include => {:versions => :maintainer},
               :page => search_results_page
    else
      q = '%' + q + '%'

      paginate :conditions => [ 'LOWER(name) LIKE ?', q],
               :include => {:versions => :maintainer},
               :page => search_results_page
    end
  end

  def self.search(q, limit=50)
    if q.ends_with? '~' # fuzzy search
      @res = Package.fuzzy_find(q[0...-1], limit)
    else
      q = '%' + q + '%'
      @res = Package.all(:conditions =>
                         ['LOWER(package.name) LIKE ? OR LOWER(version.description) LIKE ?', q, q],
                         :limit => limit, :include => :versions)
    end
    @res
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
