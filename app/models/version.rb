class Version < ActiveRecord::Base
  belongs_to :package
  
  def urls
    url.split(",")
  end
  
  def vname
    name + "_" + version
  end
end
