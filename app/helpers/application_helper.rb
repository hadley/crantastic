module ApplicationHelper
  
  def error_messages_for(object)  
    if object  
      count = object.errors.count  
    else  
      count = 0  
    end  
    
    return "" if count.zero?

    header_message = "The following errors were found:"  
    error_messages = object.errors.map {|msg| content_tag(:li, msg.join(" "))}  
    # We render the messages inside an unordered list inside a div  
    content_tag(:div,  
      content_tag(:p, header_message) + content_tag(:ul, error_messages),  
      :class => 'box'  
    )  
  end
  
  def error_message_for(object, field)
    return if object.errors[field].blank?
    errors = object.errors[field]
    errors = errors.join(" and ") if errors.is_a? Array
        
    content_tag :span, errors, :class => :error
  end
  
end
