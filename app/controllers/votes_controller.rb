class VotesController < ApplicationController

  protect_from_forgery :except => :create
  before_filter :token_required, :only => :create

  def create
    # Input should be a comma separated list of packages (with no superfluous
    # whitespace)
    packages = params[:packages].split(",")
    packages.each do |pkg|
      pkg = Package.find_by_name(pkg)
      if pkg && !self.current_user.uses?(pkg)
        self.current_user.package_users << PackageUser.new(:package => pkg)
      end
    end
    render :nothing => true, :status => 200
  end

end
