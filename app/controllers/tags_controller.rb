class TagsController < ApplicationController

  resource_controller

  actions :index, :show

  index.wants.html { @title = "Tags" }
  show.wants.html do
    set_atom_link(self, @tag)
    @events = TimelineEvent.recent_for_tag(@tag)
  end
  show.wants.atom { @events = TimelineEvent.recent_for_tag(@tag) }
  show.failure.wants.html { rescue_404 }

  private
  def object
    # Need to use =find_by_param= since we don't use numeric ids for tags.
    Tag.find_by_param(params[:id])
  end

end
