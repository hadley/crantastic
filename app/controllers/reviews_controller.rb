class ReviewsController < ApplicationController

  resource_controller

  belongs_to :user, :package, :version

  before_filter :login_required, :only => [ :new, :create  ]
  before_filter :authorization_required, :only => [ :edit, :update, :destroy  ]

  index.wants.html do
    @title = (parent_object.nil?) ? "Recent reviews" : "Reviews for #{parent_object}"
    @plural = true
  end

  show.failure.wants.html { rescue_404 }

  create.before do
    object.user = current_user # Set Review ownership
  end

  private
  def collection
    @collection ||= end_of_association_chain.recent
  end

  def parent_object
    return nil if params[:package_id].blank?
    if params[:package_id].to_i == 0
      Package.find_by_param(params[:package_id])
    else
      Package.find(params[:package_id])
    end
  end

  def build_object
    # NOTE: not sure why I have to set version_id here. bug in resource_controller?
    @object ||= end_of_association_chain.build object_params
    @object.version_id = params[:version_id]
  end

  def authorized?
    review = Review.find(params[:id])
    review.user == current_user
  end

end
