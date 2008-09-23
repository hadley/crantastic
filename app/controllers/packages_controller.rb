class PackagesController < ApplicationController
  
  # GET /package
  # GET /package.xml
  def index
     #, :include => :versions

    respond_to do |format|
      format.html do 
        @packages = Package.find(:all, :order => "lower(package.name)")
      end
      
      format.atom do
        @packages = Package.find(:all, :order => "package.created_at", :include => :versions, :conditions => "package.created_at IS NOT NULL")        
      end
    end
  end

  # GET /package/1
  # GET /package/1.xml
  def show
    id = params[:id]
    if (id.to_i != 0) 
      pkg = Package.find(id)
      response.headers["Status"] = "301 Moved Permanently"
      redirect_to url_for(pkg)
      return
    end
    
    @package = Package.find_by_name(id.gsub("-", "."))
    @version = @package.latest

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package }
    end
  end

end
