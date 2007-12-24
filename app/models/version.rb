class Version < ActiveRecord::Base
  belongs_to :package
  
  def urls
    (url.split(",") rescue []) + [cran_url]
  end
  
  def cran_url
    "http://cran.r-project.org/src/contrib/Descriptions/#{name}.html"
  end
  
  def vname
    name + "_" + version
  end
  
  def depends
    parse_requirements(attributes["depends"])
  end

  def suggests
    parse_requirements(attributes["suggests"])
  end
  
  def parse_requirements(reqs)
    reqs.split(",").map{|full| full.split(" ")[0]}.map do |name|    
      Package.find_by_name name
    end.compact.sort_by{|v| v.name.downcase } rescue []
  end

  def maintainer
    Author.new_from_string(attributes["maintainer"])
  end
    
end
