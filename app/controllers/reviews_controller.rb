class ReviewsController < ApplicationController

  resource_controller

  belongs_to :user, :package

  before_filter [ :login_required, :check_permissions ], :except => [ :index, :show ]

  index.wants.html do
    @title = (parent_object.nil?) ? "Recent reviews" : "Reviews for #{parent_object}"
    @plural = true
  end

  show.wants.html { @title = object.to_s }

  show.failure.wants.html { rescue_404 }

  create.before do
    object.user = current_user # Set Review ownership
  end

  create.flash "Your review has been saved. Thank you!"

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

end
