class TagsController < ApplicationController

  authorize_resource

  def index
    @tags = Tag.ordered
    @title = if params[:type].nil?
               "Tags"
             else
               params[:type].split('_').map(&:capitalize).join(" ").pluralize
             end
  end

  def show
    @tag = klass.find_by_param(params[:id])
    @events = TimelineEvent.recent_for_tag(@tag)
    set_atom_link(self, @tag)
  rescue ActiveRecordNotFound
    rescue_404
  end

  def create
    @tag = Tag.new(params[:tag])
    @tag.save!
  end

  def update
    @tag = Tag.find_by_param(params[:id])
    @tag.update_attributes(params[:tag])
  end

  private

  # Finds the correct ActiveRecord class for the current scope, based on the
  # 'type' param which is specified in =routes.rb=.
  def klass
    params[:type].nil? ? Tag : params[:type].classify.constantize
  end

end
