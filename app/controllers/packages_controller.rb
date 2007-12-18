class PackagesController < ApplicationController
  
  # GET /package
  # GET /package.xml
  def index
    @packages = Package.find(:all, :order => "lower(name)")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @package }
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

  # GET /package/new
  # GET /package/new.xml
  def new
    @package = Package.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @package }
    end
  end

  # GET /package/1/edit
  def edit
    @package = Package.find(params[:id])
  end

  # POST /package
  # POST /package.xml
  def create
    @package = Package.new(params[:package])

    respond_to do |format|
      if @package.save
        flash[:notice] = 'Package was successfully created.'
        format.html { redirect_to(@package) }
        format.xml  { render :xml => @package, :status => :created, :location => @package }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @package.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /package/1
  # PUT /package/1.xml
  def update
    @package = Package.find(params[:id])

    respond_to do |format|
      if @package.update_attributes(params[:package])
        flash[:notice] = 'Package was successfully updated.'
        format.html { redirect_to(@package) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @package.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /package/1
  # DELETE /package/1.xml
  def destroy
    @package = Package.find(params[:id])
    @package.destroy

    respond_to do |format|
      format.html { redirect_to(package_url) }
      format.xml  { head :ok }
    end
  end
end
