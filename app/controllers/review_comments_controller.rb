class ReviewCommentsController < ApplicationController

  resource_controller

  belongs_to :review

  before_filter :valid_login_required, :except => :show

  show.failure.wants.html { rescue_404 }

  create.before { object.user = current_user }

  create.wants.html { redirect_to package_review_url(@review.package, @review) }

  create.flash "Your review comment has been saved. Thank you!"

end
