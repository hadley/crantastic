class PackagesController < ApplicationController
  @@package_table = Package.table_name

  def index
    page_no = params[:page] || 1
    @search_term = String(params[:search])
    
    respond_to do |format|
      format.html do 
        @packages = Package.search(@search_term, params[:page])
      end
      format.js do 
        @packages = Package.search(@search_term, params[:page])
        render :partial => "packages/list"
      end
      
      format.atom do
        @packages = Package.find(:all, :order => "#{@@package_table}.created_at", :include => :versions, :conditions => "#{@@package_table}.created_at IS NOT NULL")        
      end
    end
  end

  # GET /packages
  # GET /packages.xml
  def index_old
    #, :include => :versions
    respond_to do |format|
      format.html do 
        @packages = Package.find(:all, :order => "lower(#{@@package_table}.name)")
      end
      
      format.atom do
        @packages = Package.find(:all, :order => "#{@@package_table}.created_at", :include => :versions, :conditions => "#{@@package_table}.created_at IS NOT NULL")        
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
