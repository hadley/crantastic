class RatingsController < ApplicationController
  before_filter :login_required, :only => [ :create ]

  def create
    @package = Package.find_by_name(params[:package_id])
    current_user.rate!(@package, params[:rating].to_i)

    flash[:notice] = "Thanks for your vote!"

    respond_to do |format|
      format.html { redirect_to(package_path(@package)) }
      #format.js {}
      #format.atom {}
    end
  end
end
