class Package < ActiveRecord::Base
  has_many :versions
  
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
