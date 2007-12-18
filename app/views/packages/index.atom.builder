atom_feed do |feed|
  feed.title("Updated packages")
  feed.updated((@packages.first.created_at))

  for package in @packages
    feed.entry(package) do |entry|
      entry.title(package.name + " added")
      entry.content([package.latest.title, package.latest.description].compact.join("\n"))

      entry.author do |author|
        author.name("crantastic.org")
      end
    end
  end
end