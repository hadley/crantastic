class RatingsController < ApplicationController

  before_filter :login_required, :only => [ :create ]

  def index
    return rescue_404 if params[:package_id].nil?
    pkg = Package.find_by_param(params[:package_id])

    respond_to do |format|
      format.html { redirect_to(package_path(pkg)) }
      format.js do
        render :json => {
          :average_rating => pkg.average_rating(params[:aspect]),
          :votes => pkg.rating_count(params[:aspect])
        }.to_json
      end
    end
  end

  def create
    @package = Package.find_by_param(params[:package_id])
    current_user.rate!(@package, params[:rating].to_i, params[:aspect])

    flash[:notice] = "Thanks for your vote!"

    respond_to do |format|
      format.html { redirect_to(package_path(@package)) }
      format.js { render :status => 200, :nothing => true }
    end
  end

end
