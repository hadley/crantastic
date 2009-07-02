class TagsController < ApplicationController

  resource_controller

  actions :index, :show

  index.wants.html { @title = "Tags" }
  show.before { @events = TimelineEvent.recent_for_tag(@tag) }
  show.wants.html { set_atom_link(self, @tag) }
  show.wants.atom {}
  show.failure.wants.html { rescue_404 }

  private
  def collection
    Tag.ordered
  end

  def object
    # Need to use =find_by_param= since we don't use numeric ids for tags.
    Tag.find_by_param(params[:id])
  end

end
