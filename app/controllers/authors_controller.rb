class AuthorsController < ApplicationController

  resource_controller

  actions :index, :show

  index.wants.html { @title = "Package Maintainers" }
  index.wants.xml { render :xml => @authors }
  show.before { @events = TimelineEvent.recent_for_author(@author) }
  show.wants.html do
    set_atom_link(self, @author)
    @plural = false
    @title = @author.name
  end
  show.wants.atom {}
  show.wants.xml { render :xml => @author }

  show.failure.wants.html { rescue_404 }

  def collection
    conditions = params.dup.delete_if { |k,v| !["name", "email"].include?(k) }
    Author.all(:conditions => conditions)
  end

end
