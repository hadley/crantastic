class Version < ActiveRecord::Base
  belongs_to :package
  
  def urls
    url.split(",") + [cran_url]
  end
  
  def cran_url
    "http://cran.r-project.org/src/contrib/Descriptions/#{name}.html"
  end
  
  def vname
    name + "_" + version
  end
end
