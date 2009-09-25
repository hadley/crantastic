class TagsController < ApplicationController

  resource_controller

  actions :index, :show, :edit, :update

  before_filter [ :valid_login_required, :check_permissions ],
                :except => [ :index, :show ]

  index.wants.html do
    @title = if params[:type].nil?
               "Tags"
             else
               params[:type].split('_').map(&:capitalize).join(" ").pluralize
             end
  end
  show.before { @events = TimelineEvent.recent_for_tag(@tag) }
  show.wants.html { set_atom_link(self, @tag) }
  show.wants.atom {}
  show.failure.wants.html { rescue_404 }

  private

  def collection
    klass.ordered
  end

  def object
    # Need to use =find_by_param= since we don't use numeric ids for tags.
    klass.find_by_param(params[:id])
  end

  # Finds the correct ActiveRecord class for the current scope, based on the
  # 'type' param which is specified in =routes.rb=.
  def klass
    params[:type].nil? ? Tag : params[:type].classify.constantize
  end

end
