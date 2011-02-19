class VersionsController < ApplicationController

  before_filter :admin_required, :only => :create

  protect_from_forgery :except => :trigger

  def index
    respond_to do |format|
      format.html { rescue_404 }
      format.xml { render :xml => Version.all }
    end
  end

  def show
    @version = Version.find(params[:id])
    @package = @version.package
  end

  def create
    @version = Version.new(params[:version])
    if @version.save
      render :xml => @version
    else
      render :nothing => true, :status => :conflict
    end
  end

  def feed
    @versions = Version.recent
    respond_to do |format|
      format.atom
    end
  end

  def trigger
    #Version.find(params[:id]).serialize_data
    render :nothing => true
  end

end
