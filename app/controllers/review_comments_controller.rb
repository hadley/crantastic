class ReviewCommentsController < ApplicationController

  resource_controller

  belongs_to :review

  before_filter :login_required, :except => :show
  before_filter :check_package_authorship, :only => :create

  show.failure.wants.html { rescue_404 }

  create.before { object.user = current_user }

  create.wants.html { redirect_to package_review_url(@review.package, @review) }

  create.flash "Your review comment has been saved. Thank you!"

  private
  def check_package_authorship
    unless current_user.author_of?(Review.find(params[:review_id]).package)
      render :text => "Unauthorized", :status => :forbidden
    end
  end

end
