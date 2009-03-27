class Package < ActiveRecord::Base
  default_scope :order => "LOWER(name)"
  has_many :versions, :order => "id DESC"
  has_many :reviews
  has_many :taggings
  
  ## No. of packages to show per page.
  def self.per_page; 50; end
  
  ## Search On Name of Package.
  def self.search(search_term, search_results_page)
    search_term = '%' + String(search_term).downcase + '%'
    
    paginate :conditions => [ 'LOWER(name) LIKE ?', search_term],
             :include => {:versions => :maintainer},
             :per_page => Package.per_page,
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
