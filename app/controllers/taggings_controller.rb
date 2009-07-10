class TaggingsController < ApplicationController

  resource_controller

  protect_from_forgery :except => :create
  before_filter :login_or_token_required
  before_filter :check_permissions, :only => [ :destroy ]

  belongs_to :package

  create.before do
    # params[:tag_name] might be a list of tags, an array of tag instances is
    # returned by the following statement.
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

    wants.xml do
      render :xml => @tagging, :status => :created, :location => @tagging.package
    end

    failure do
      flash "Tag name did not pass validation - please try again.
             Only alphanumeric characters are allowed. You can only
             apply a tag once to a given package."

      wants.xml { render :nothing => true, :status => 400 }
    end
  end

  private

  def parent_object
    Package.find_by_param(params[:package_id])
  end

end
