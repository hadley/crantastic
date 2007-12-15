class VersionsController < ApplicationController
  # GET /version
  # GET /version.xml
  def index
    @version = Version.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @version }
    end
  end

  # GET /version/1
  # GET /version/1.xml
  def show
    @version = Version.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @version }
    end
  end

  # GET /version/new
  # GET /version/new.xml
  def new
    @version = Version.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @version }
    end
  end

  # GET /version/1/edit
  def edit
    @version = Version.find(params[:id])
  end

  # POST /version
  # POST /version.xml
  def create
    @version = Version.new(params[:version])

    respond_to do |format|
      if @version.save
        flash[:notice] = 'Version was successfully created.'
        format.html { redirect_to(@version) }
        format.xml  { render :xml => @version, :status => :created, :location => @version }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @version.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /version/1
  # PUT /version/1.xml
  def update
    @version = Version.find(params[:id])

    respond_to do |format|
      if @version.update_attributes(params[:version])
        flash[:notice] = 'Version was successfully updated.'
        format.html { redirect_to(@version) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @version.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /version/1
  # DELETE /version/1.xml
  def destroy
    @version = Version.find(params[:id])
    @version.destroy

    respond_to do |format|
      format.html { redirect_to(version_url) }
      format.xml  { head :ok }
    end
  end
end
