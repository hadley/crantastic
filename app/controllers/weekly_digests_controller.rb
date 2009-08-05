class WeeklyDigestsController < ApplicationController

  resource_controller

  actions :index, :show

  before_filter :set_atom

  index.wants.html { @title = @atom[:title] }
  index.wants.atom { }
  show.wants.html { @title = object.title }
  show.failure.wants.html { rescue_404 }

  private

  def object
    WeeklyDigest.find_by_param(params[:id])
  end

  def set_atom
    @atom = {
      :url => "http://feeds.feedburner.com/WeeklyDigestsOnCrantastic",
      :title => "Weekly digests",
      :text => "Follow our weekly digests"
    }
  end

end
