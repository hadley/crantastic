class AuthorsController < ApplicationController

  resource_controller

  actions :index, :show # Only index and show for Authors

  index.wants.html { @title = "Package Maintainers" }
  show.before { @events = TimelineEvent.recent_for_author(@author) }
  show.wants.html do
    set_atom_link(self, @author)
    @plural = false
    @title = @author.name
  end
  show.wants.atom {}

  show.failure.wants.html { rescue_404 }

end
