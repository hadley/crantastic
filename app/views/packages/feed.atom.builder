atom_feed(:root_url => packages_url) do |feed|
  feed.title("New packages on crantastic")
  feed.subtitle("New packages available on CRAN. " +
                "Does not include new versions of existing packages.")
  feed.updated(@packages.first.created_at)
  feed.author do |author|
    author.name("crantastic.org")
  end

  for package in @packages
    # Use created_at as the updated value since this feed only concerns itself
    # with when packages are published, not when they are updated.
    next if package.latest.nil?
    feed.entry(package, :updated => package.created_at) do |entry|
      entry.title(package.name + " added")
      entry.content(content_tag("p", content_tag("strong", package.latest.title)) +
                    content_tag("p", package.latest.description), :type => "html")
    end
  end
end
