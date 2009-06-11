class ReviewsController < ApplicationController

  resource_controller

  belongs_to :user, :package

  before_filter :login_required, :only => [ :new, :create  ]
  before_filter :authorization_required, :only => [ :edit, :update  ]

  show.failure.wants.html { rescue_404 }

  create.before { object.user = current_user } # Set Review ownership

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

  def authorized?
    review = Review.find(params[:id])
    review.user == current_user
  end

end
