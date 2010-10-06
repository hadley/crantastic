module FeedHelper

  # Obj is set to nil for the main timeline feed
  def latest_activity_feed(obj=nil)
    xml = ::Builder::XmlMarkup.new(:indent => 2)
    root = obj.nil? ? root_url : polymorphic_url(obj)
    raw(atom_feed(:root_url => root) do |feed|
      feed.title("Latest activity " + (obj.nil? ? "on crantastic" : "for #{obj}"))
      feed.updated(obj.nil? ? @timeline_events.first.updated_at : obj.updated_at)
      feed.author do |author|
        author.name("crantastic.org")
      end

      for event in @timeline_events
        feed.entry(event) do |entry|
          event_html = timeline_event(event, false) # don't include time ago in feeds
          next if event_html.blank? # Skip e.g. double entries for new packages
          entry.title(strip_tags(event_html))

          # sanitize strips away the ul/li tags
          content = sanitize(event_html, :tags => %w(a href p span))

          if event.package_event?
            content += "<br /><h3>Package description:</h3><p>#{event.subject.description}</p>".html_safe
          end

          entry.content(content, :type => 'html')

          entry.author do |author|
            author.name(event.actor.nil? ? "crantastic.org" : event.actor.login)
          end
        end
      end
    end)
  end

end
