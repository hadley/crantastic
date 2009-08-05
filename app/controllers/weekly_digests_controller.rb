class WeeklyDigestsController < ApplicationController

  resource_controller

  actions :index, :show, :daily

  before_filter :set_atom

  index.wants.html { @title = @atom[:title] }
  index.wants.atom { }
  show.wants.html { @title = object.title }
  show.failure.wants.html { rescue_404 }

  # Feels dirty to render the daily digests from here, but a separate controller
  # would be overkill. Leaving it like this for now.
  def daily
    object # Initializing to make sure that the passed in day is
    # acceptable. Else a 404 will be raised.
    render :template => "weekly_digests/show"
  rescue ActiveRecord::RecordNotFound
    rescue_404
  end

  private

  def object(day=false)
    params[:day] ? DailyDigest.find_by_param(params[:day]) : WeeklyDigest.find_by_param(params[:id])
  end

  def set_atom
    @atom = {
      :url => "http://feeds.feedburner.com/WeeklyDigestsOnCrantastic",
      :title => "Weekly digests",
      :text => "Follow our weekly digests"
    }
  end

end
