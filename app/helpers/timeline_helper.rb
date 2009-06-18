module TimelineHelper

  def timeline_item(item)
    link_to(item.actor, user_path(item.actor)) + " " +
    case item.event_type
    when "new_tagging" then
      content_tag("span", "tagged", :class => "action") + " " +
        link_to(item.secondary_subject, item.secondary_subject) +
        " with #{link_to(item.subject.tag, item.subject.tag)}"

    when "new_package_rating" then
      content_tag("span", "rated", :class => "action") + " " +
        link_to(item.secondary_subject, item.subject.package) +
        "#{item.subject.aspect == 'overall' ? '' : '\'s documentation'}" +
        " with " + content_tag("span", "#{item.subject.rating} stars", :class => "red")

    when "new_review" then
      content_tag("span", "reviewed", :class => "action") + " " +
        link_to(item.secondary_subject, item.secondary_subject) +
        " with " + link_to("these words", item.subject)

    else "performed an unkown action"

    end + " <strong>#{time_ago_in_words(item.created_at)} ago</strong>."
  end

end
