module ApplicationHelper

  def error_message_for(object, field)
    return if object.errors[field].blank?
    errors = object.errors[field]
    errors = errors.join(" and ") if errors.is_a? Array

    content_tag :span, errors, :class => :error
  end

  def clear_div
    content_tag(:div, nil, :class => :clear)
  end

end
