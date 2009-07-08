class VotesController < ApplicationController

  protect_from_forgery :except => :create
  before_filter :require_valid_token, :only => :create

  def create
    user = User.find_by_token(params[:token])
    # Input should be a comma separated list of packages (with no superfluous
    # whitespace)
    packages = params[:packages].split(",")
    packages.each do |pkg|
      pkg = Package.find_by_name(pkg)
      if pkg && !user.voted_for?(pkg)
        user.package_votes << PackageVote.new(:package => pkg)
      end
    end
    render :nothing => true, :status => 200
  end

end
