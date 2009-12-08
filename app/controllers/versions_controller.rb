class VersionsController < ApplicationController

  resource_controller

  actions :index, :show, :create

  belongs_to :package

  before_filter :admin_required, :only => :create

  protect_from_forgery :except => :trigger

  index.wants.html { rescue_404 }
  index.wants.xml { render :xml => collection }

  show.failure.wants.html { rescue_404 }

  create.wants.xml { render :xml => object }
  create.failure.wants.xml { render :nothing => true, :status => :conflict }

  def feed
    @versions = Version.recent
    respond_to do |format|
      format.atom
    end
  end

  def trigger
    Version.find(params[:id]).serialize_data
    render :nothing => true
  end

  private
  def parent_object
    # Find the parent package object with the param instead of numeric id
    Package.find_by_param(params[:package_id])
  end

end
