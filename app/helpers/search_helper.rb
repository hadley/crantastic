module SearchHelper
  def star_rating_for(package)
    # The nbsp's are ugly, but it was the first technique that I got working in
    # both FF, Safari, and Opera.
    content_tag("span", "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", :class => "star-rating-on") * package.average_rating
  end
end
