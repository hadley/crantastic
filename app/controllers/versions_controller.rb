class VersionsController < ApplicationController

  resource_controller

  actions :index, :show

  belongs_to :package

  # We don't currently have an index page for Versions, so simply do a 404.
  index.wants.html { rescue_404 }

  show.failure.wants.html { rescue_404 }

  def feed
    @versions = Version.recent
    respond_to do |format|
      format.atom
    end
  end

  private
  def parent_object
    # Find the parent package object with the param instead of numeric id
    Package.find_by_param(params[:package_id])
  end

end
