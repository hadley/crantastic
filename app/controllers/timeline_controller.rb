class TimelineController < ApplicationController

  # Scoped timeline
  def show
    @events =
      if params[:task_view_id] or params[:tag_id]

        name = params[:task_view_id] ? params[:task_view_id] : params[:tag_id]
        package_ids = Tagging.all(:include => :tag,
                                  :conditions => ["tag.name = ?", name]).map(&:package_id)
        TimelineEvent.recent_for_package_ids(package_ids)

      elsif params[:user_id]

        u = User.find(params[:user_id])
        TimelineEvent.recent_for_user(u)

      else
        []
      end
  rescue
    rescue_404
  end

end
