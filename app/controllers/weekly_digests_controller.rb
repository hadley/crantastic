class WeeklyDigestsController < ApplicationController

  resource_controller

  show.wants.html {}
  show.failure.wants.html { rescue_404 }

  private

  def object
    WeeklyDigest.find_by_param(params[:id])
  end

end
