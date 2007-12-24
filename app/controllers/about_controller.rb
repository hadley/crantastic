class AboutController < ApplicationController
  def index
  end
  
  def authors
    @versions = (Version.find :all, :order => :maintainer)
  end
end
