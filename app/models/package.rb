class Package < ActiveRecord::Base
  has_many :versions
  
  def latest
    versions[0]
  end
  
  def cran_url
    "http://cran.r-project.org/src/contrib/Descriptions/#{name}.html"
  end
end
