class WeeklyDigestsController < ApplicationController

  resource_controller

  show.before do
    @reviews = object.new_reviews
    @packages = object.new_packages.sort
    @versions = object.new_versions.sort
  end
  show.wants.html { @title = object.title }
  show.failure.wants.html { rescue_404 }

  private

  def object
    WeeklyDigest.find_by_param(params[:id])
  end

end
