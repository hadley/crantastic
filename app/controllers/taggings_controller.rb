class TaggingsController < ApplicationController
  before_filter :login_required, :only => [ :new, :create  ]
  before_filter :authorization_required, :only => [ :edit, :update  ]

  resource_controller

  def authorized?
    tagging = Tagging.find(params[:id])
    tagging.user == current_user
  end

  new_action.before do
    @tagging = Tagging.new
    @tagging.user = current_user
    @tagging.package = Package.find(params[:package_id])
  end

  create do
    flash 'Tagging was successfully created.'
    wants.html { redirect_to(@tagging.package) }
    wants.xml { render :xml => @tagging, :status => :created, :location => @tagging }

    failure do
      flash "Tag name did not pass validation - please try again"
    end
  end
end
