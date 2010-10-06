class TaggingsController < ApplicationController

  protect_from_forgery :except => :create
  before_filter :login_required, :set_object

  def create
    # params[:tag_name] might be a list of tags, an array of tag instances is
    # returned by the following statement.
    tags = Tag.parse_and_find_or_create(params[:tag_name])
    @tagging.tag = tags.first # Good enough for now

    throw ActiveRecord::RecordInvalid if tags.empty?

    tags.each do |t|
      Tagging.create(:user => self.current_user, :tag => t,
                     :package => @package)
    end

    flash[:notice] = 'Package tagged succesfully'

    respond_to do |format|
      format.html { redirect_to(@package) }
      format.xml do
        render :xml => @tagging, :status => :created, :location => @package
      end
    end

  rescue
    flash[:notice] = "Tag name did not pass validation - please try again.
                     Only alphanumeric characters are allowed. You can only
                     apply a tag once to a given package."

    respond_to do |format|
      format.html { render :action  => :new }
      format.xml  { render :nothing => true, :status => 400 }
    end
  end

  def destroy
    authorize! :destroy, object
    object.destroy

    respond_to do |format|
      format.html { redirect_to(@tagging.package) }
      format.xml  { head :ok }
    end
  end

  def object
    @tagging
  end

  private

  def set_object
    @package = Package.find_by_param(params[:package_id])
    @tagging = if params[:id]
                 Tagging.find(params[:id])
               else
                 Tagging.new(:user => current_user, :package => @package)
               end
  end

  def single_access_allowed?
    action_name == "create"
  end

end
