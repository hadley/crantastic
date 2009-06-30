atom_feed do |feed|
  feed.title("Latest activity for #{@tag}")
  feed.updated(@tag.updated_at)

  for event in @events
    feed.entry(event) do |entry|
      event_html = timeline_event(event, false) # don't include time ago in feeds
      entry.title(strip_tags(event_html))

      # sanitize strips away the ul/li tags
      entry.content(sanitize(event_html, :tags => %w(a href p span)), :type => 'html')

      if event.actor
        entry.author do |author|
          author.name(event.actor.login)
        end
      end
    end
  end
end
