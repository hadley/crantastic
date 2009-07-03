atom_feed(:root_url => root_url) do |feed|
  feed.title("New package versions on crantastic")
  feed.subtitle("New package versions available on CRAN.")
  feed.updated(@versions.first.created_at)
  feed.author do |author|
    author.name("crantastic.org")
  end

  for version in @versions
    # Use created_at as the updated value since this feed only concerns itself
    # with when versions are published, not when they are updated.
    feed.entry(version,
               :url => package_url(version.package),
               :updated => version.created_at) do |entry|
      entry.title(version.name + " was upgraded to version #{version}")
      content = content_tag("p", content_tag("strong", version.title)) +
        content_tag("p", version.description)
      unless version.readme.blank?
        content += content_tag("h3", "Readme") + content_tag("pre", version.readme)
      end
      unless version.changelog.blank?
        content += content_tag("h3", "Changelog") + content_tag("pre", version.changelog)
      end
      unless version.news.blank?
        content += content_tag("h3", "News") + content_tag("pre", version.news)
      end
      entry.content(content, :type => "html")
    end
  end
end
