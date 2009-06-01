class ReviewsController < ApplicationController

  resource_controller

  belongs_to :user, :package

  before_filter :login_required, :only => [ :new, :create  ]
  before_filter :authorization_required, :only => [ :edit, :update  ]

  show.failure.wants.html do
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end

  create.before { object.user = current_user } # Set Review ownership

  private
  def collection
    @collection ||= Review.recent
  end

  def authorized?
    review = Review.find(params[:id])
    review.user == current_user
  end

end
