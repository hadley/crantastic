# Simple controller for (semi) static pages. Each page requires a new entry
# in =routes.rb=. If we end up with many of these pages we should look into a
# more sophisticated solution.

class StaticController < ApplicationController

  def about
    @title = "About"
  end

  def error_404
  end

  def error_500
  end

  # We don't want the staging server to get indexed by crawlers, so we must
  # serve a dynamic robots.txt file.
  def robots_txt
    text = <<EOF
# See http://www.robotstxt.org/wc/norobots.html for documentation on how to use the robots.txt file
#
# To ban all spiders from the entire site uncomment the next two lines:
# User-Agent: *
# Disallow: /
EOF
    if request.env["HTTP_HOST"] == "dev.crantastic.org"
      text += "User-Agent: *\n"
      text += "Disallow: /\n"
    end
    render :text => text, :status => 200, :content_type => "text/plain"
  end

  def welcome
    @title = "Welcome"
  end

end
