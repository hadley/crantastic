class TimelineEventsController < ApplicationController

  resource_controller

  actions :index, :show

  before_filter :set_atom

  show.failure.wants.html { rescue_404 }
  index.wants.atom { @events = @timeline_events }
  index.wants.js { render :partial => "paginated_events", :locals => { :events => @timeline_events } }

  private
  def collection
    @page = params[:page] || 1
    TimelineEvent.paginate_recent(@page)
  end

  def set_atom
    @atom = {
      :url => "http://feeds.feedburner.com/LatestActivityOnCrantastic",
      :title => "Latest activity on crantastic"
    }
  end

end
