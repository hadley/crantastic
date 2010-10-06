class WeeklyDigestsController < ApplicationController

  before_filter :set_atom

  def index
    @weekly_digests = WeeklyDigest.all
    @title = @atom[:title]
    respond_to do |format|
      format.html { }
      format.text { }
    end
  end

  def show
    @digest = object
    @title = @digest.title
    respond_to do |format|
      format.html { }
      format.text { }
    end
  end

  # Feels dirty to render the daily digests from here, but a separate controller
  # would be overkill. Leaving it like this for now.
  # TODO should have .txt as well
  def daily
    @digest = object
    render :template => "weekly_digests/show"
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
