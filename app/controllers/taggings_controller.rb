class TaggingsController < ApplicationController

  before_filter :login_required, :only => [ :new, :create ]
  before_filter :authorization_required, :only => [ :destroy ]

  resource_controller

  belongs_to :user, :package

  create.before do
    # Tags are found using case-insensitive LIKE statement. This way,
    # e.g. "Visual Interface" and "Visual interface" will be hooked up to the
    # same tag. The tag will be created if it wasn't already in the db.

    tags = Tag.parse_and_find_or_create(params[:tag_name])

    # Hack hack hack. Not sure of how I could do this more elegantly with resource_controller
    if tags.size > 1
      tags[1..-1].each do |t|
        Tagging.create!(:user => self.current_user, :tag => t, :package => parent_object)
      end
    end

    @tagging.tag = tags.first
    @tagging.user = current_user # Set tagging ownership
  end

  create do
    flash 'Package tagged succesfully'
    wants.html { redirect_to(@tagging.package) }
    wants.xml { render :xml => @tagging, :status => :created, :location => @tagging }

    failure do
      flash "Tag name did not pass validation - please try again.
             Only alphanumeric characters are allowed. You can only
             apply a tag once to a given package."
    end
  end

  private
  def authorized?
    tagging = Tagging.find(params[:id])
    tagging.user == current_user
  end

  def parent_object
    Package.find_by_param(params[:package_id])
  end

end
