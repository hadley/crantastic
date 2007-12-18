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
        @packages = Package.find(:all, :order => "package.created_at", :include => :versions)        
      end
    end
  end

  # GET /package/1
  # GET /package/1.xml
  def show
    @package = Package.find(params[:id])
    @version = @package.latest

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package }
    end
  end

end
