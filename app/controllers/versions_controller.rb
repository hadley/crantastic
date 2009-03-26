class VersionsController < ApplicationController
  # GET /version
  # GET /version.xml
  def index
    @versions = Version.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @versions }
    end
  end

  # GET /version/1
  # GET /version/1.xml
  def show
    @version = Version.find(params[:id])
    @package = Package.find_by_name(params[:package_id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @version }
    end
  end
end
