class AuthorsController < ApplicationController

  resource_controller

  actions :index, :show # Only index and show for Authors

  index.wants.html { @title = "Package Maintainers" }
  show.wants.html do
    @plural = false
    @title = @author.name
  end

  show.failure.wants.html { rescue_404 }

end
