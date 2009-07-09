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

  def title
    plural = @plural
    plural = (@title.pluralize == @title) unless @title.nil? or plural == false
    "#{@title + ". " if @title}#{plural ? "They're" : "It's"} crantastic!"
  end

  def this_is_me?
    current_user == @user
  end

  # C.f. https://wiki.mozilla.org/The_autocomplete_attribute_and_web_documents_using_XHTML
  def nonce_field(name, options = {})
    nonce = Rack::Auth::Digest::Nonce.new.to_s
    hidden_field_tag(name, nonce) +
      text_field_tag(nonce, nil, options)
  end

  def markdown(text)
    text = h(gfm(text))
    # Extract and highlight code blocks
    text.gsub!(%r{\+BEGIN_SRC(.+)\+END_SRC}m) do |match|
      content_tag("code", match.scan(%r{\+BEGIN_SRC(.+)\+END_SRC}m)[0][0],
                  :class => "prettyprint")
    end
    auto_link(Maruku.new(text).to_html)
  end

end
