class TimelineEventsController < ApplicationController

  resource_controller

  actions :index, :show

  show.failure.wants.html { rescue_404 }

  private
  def collection
    TimelineEvent.recent
  end

end
