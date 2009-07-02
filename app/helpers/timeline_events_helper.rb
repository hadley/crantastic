module TimelineEventsHelper

  def timeline_event(item, display_time_ago=true)
    "<li>" +
    (item.actor.not_nil? ? link_to(item.actor, user_path(item.actor)) + " " : "") +
    case item.event_type

    when "new_package" then

      # Maybe include version number here
      link_to(item.subject, item.subject) + " was " +
        content_tag("span", "released", :class => "action")

    when "new_version" then

      # Don't display a message twice for a package release, so we must check
      # the previous event
      prev = TimelineEvent.find(item.id - 1)
      return "" if prev.event_type == "new_package" &&
        prev.secondary_subject == item.secondary_subject

      link_to(item.secondary_subject, item.secondary_subject) + " was " +
        content_tag("span", "upgraded", :class => "action") +
        " to version " +
        link_to(item.subject, package_version_path(item.subject.package, item.subject))

    when "new_tagging" then

      content_tag("span", "tagged", :class => "action") + " " +
        link_to(item.secondary_subject, item.secondary_subject) +
        " with #{link_to(item.subject.tag, item.subject.tag)}"

    when "updated_task_view" then

      link_to(item.subject, item.subject) + " was " +
        content_tag("span", "updated", :class => "action") +
        " to version #{item.cached_value}"

    when "new_package_rating" then

      content_tag("span", "rated", :class => "action") + " " +
        link_to(item.secondary_subject, item.subject.package) +
        "#{item.subject.aspect == 'overall' ? '' : '\'s documentation'}" +
        " with " + content_tag("span", "#{item.cached_value} stars", :class => "red")

    when "new_review" then

      content_tag("span", "reviewed", :class => "action") + " " +
        link_to(item.secondary_subject, item.secondary_subject) +
        " with " + link_to("these words", item.subject)

    else "performed an unkown action"

    end +
      (display_time_ago ? " (#{time_ago_in_words(item.created_at)} ago)" : "") +
       ".</li>"
  end

end
