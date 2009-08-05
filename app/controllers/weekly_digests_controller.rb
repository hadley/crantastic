class WeeklyDigestsController < ApplicationController

  resource_controller

  index.wants.atom {}
  show.wants.html { @title = object.title }
  show.failure.wants.html { rescue_404 }

  private

  def object
    WeeklyDigest.find_by_param(params[:id])
  end

end
