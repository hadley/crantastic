atom_feed(:root_url => polymorphic_url(@tag)) do |feed|
  feed.title("Latest activity for #{@tag}")
  feed.updated(@tag.updated_at)

  for event in @events
    feed.entry(event) do |entry|
      event_html = timeline_event(event, false) # don't include time ago in feeds
      entry.title(strip_tags(event_html))

      # sanitize strips away the ul/li tags
      entry.content(sanitize(event_html, :tags => %w(a href p span)), :type => 'html')

      entry.author do |author|
        author.name(event.actor.nil? ? "crantastic" : event.actor.login)
      end
    end
  end
end
