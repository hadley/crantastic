atom_feed(:root_url => weekly_digests_url) do |feed|
  feed.title("Weekly digests on crantastic")
  feed.updated(@weekly_digests.first.updated_at)
  feed.author do |author|
    author.name("crantastic.org")
  end

  for wd in @weekly_digests
    feed.entry(wd) do |entry|
      entry.title(wd.title)

      content = reviews(wd.reviews) + packages(wd.packages) + versions(wd.versions)
      entry.content(content, :type => 'html')

      entry.author do |author|
        author.name("crantastic.org")
      end
    end
  end
end
