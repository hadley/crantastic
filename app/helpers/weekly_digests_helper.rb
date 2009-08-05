module WeeklyDigestsHelper

  def reviews(reviews)
    return if reviews.empty?
    content_tag(:h2, "Reviews") +
      content_tag(:ul, reviews.map do |r|
                         content_tag(:li, link_to("#{r.user}'s review of #{r.package}", r))
                       end)
  end

  def packages(packages)
    return if packages.empty?
    content_tag(:h2, "Package releases") +
    content_tag(:p, package_links(packages))
  end

  def versions(versions)
    return if versions.empty?
    content_tag(:h2, "Version upgrades") +
    content_tag(:p, versions.collect { |v| package_version(v.package, v, true, '') }.join(", "))
  end

end
