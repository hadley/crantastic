module TimelineEventsHelper

  def action(action_txt)
    content_tag("span", action_txt, :class => "action")
  end

  def user_action(event_type, events, display_action=true)
    case event_type

    when "new_tagging" then

      action("tagged") + " " +
        events.map do |e|
        link_to(e.secondary_subject, e.secondary_subject) +
          " with #{link_to(e.subject.tag, e.subject.tag)}".html_safe
      end.to_sentence.html_safe

    when "new_package_rating" then

      action("rated") + " " +
        events.map do |e|
        link_to(e.secondary_subject, e.secondary_subject) +
          "#{e.subject.aspect == 'overall' ? '' : '\'s documentation'}" +
          " with " + content_tag("span", "#{e.cached_value} stars", :class => "red")
      end.to_sentence.html_safe

    when "new_package_user" then

      action("uses") + " " +
        events.map do |e|
          link_to(e.secondary_subject, e.secondary_subject)
        end.to_sentence.html_safe

    when "new_review" then

      action("reviewed") + " " +
        events.map do |e|
          link_to(e.secondary_subject, e.secondary_subject) +
            " with " + link_to("these words", [e.subject.package, e.subject])
        end.to_sentence.html_safe

    end
  end

  def timeline_event(item, display_time_ago=true, li=true)

    output = if item.package_event?
               case item.event_type

               when "new_package" then
                 return "" if item.subject.nil?
                 # Maybe include version number here
                 link_to(item.subject, item.subject) + " was " + action("released")

               when "new_version" then

                 link_to(item.secondary_subject, item.secondary_subject) + " was " +
                   action("upgraded") + " to version " +
                   link_to(item.subject, package_version_path(item.subject.package, item.subject))
               end

             elsif item.user_event?

               link_to(item.actor, item.actor) + " " +
                 if item.kind_of? FilteredEvent
                   item.events.map { |(k,v)| user_action(k, v) }.to_sentence.html_safe
                 else
                   user_action(item.event_type, [item])
                 end

             else

               case item.event_type

               when "updated_task_view" then
                 link_to(item.subject, item.subject) + " was " + action("updated") +
                   " to version #{item.cached_value}"
               end

             end

    output = "performed an unkown action" if output.blank?

    output += " (#{time_ago_in_words(item.created_at)} ago)" if display_time_ago
    content_tag(:li, output) if li
  end

end
