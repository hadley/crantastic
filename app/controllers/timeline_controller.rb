class TimelineController < ApplicationController

  # Scoped timeline
  def show
    @events =
      if params[:package_id]

        # We only do this find call to catch 404's
        p = Package.find_by_param(params[:package_id])
        TimelineEvent.recent_for_package_ids(p.id)

      elsif params[:task_view_id] or params[:tag_id]

        name = params[:task_view_id] ? params[:task_view_id] : params[:tag_id]
        TimelineEvent.recent_for_tag(name)

      elsif params[:user_id]

        u = User.find(params[:user_id]) # For 404's
        TimelineEvent.recent_for_user(u)

      else
        []
      end
  rescue
    rescue_404
  end

end
