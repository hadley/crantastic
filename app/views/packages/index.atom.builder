atom_feed(:root_url => packages_url) do |feed|
  feed.title("New packages")
  feed.subtitle("New packages available on CRAN. Does not include new versions of existing packages.")
  feed.updated((@packages.first.created_at))
  feed.author do |author|
    author.name("crantastic.org")
  end

  for package in @packages
    feed.entry(package) do |entry|
      entry.title(package.name + " added")
      entry.content(
        [package.latest.title, package.latest.description].compact.join("\n"),
        :type => "text"
      )
      entry.published(package.created_at)

    end
  end
end