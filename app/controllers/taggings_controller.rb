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
    @tagging.package = Package.find(params[:package_id])
  end

  create.before do
    # Tags are found using case-insensitive LIKE statement. This way,
    # e.g. "Visual Interface" and "Visual interface" will be hooked up to the
    # same tag. The tag will be created if it wasn't already in the db.
    @tagging.tag = Tag.find_or_create_with_like_by_name(params[:tag_name])
    @tagging.user = current_user # Set tagging ownership
  end

  create do
    flash 'Tagging was successfully created.'
    wants.html { redirect_to(@tagging.package) }
    wants.xml { render :xml => @tagging, :status => :created, :location => @tagging }

    failure do
      flash "Tag name did not pass validation - please try again.
             Only alphanumeric characters are allowed. You can only
             apply a tag once to a given package."
    end
  end
end
