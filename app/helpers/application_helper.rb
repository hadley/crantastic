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
    "#{@title + ". " if @title}#{plural ? "They're" : "It's"} crantastic!".html_safe
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
    sanitize(auto_link(Maruku.new(text).to_html))
  end

  def markdown_enabled_msg(extra_text=nil)
    out = "(#{link_to "Markdown", "http://daringfireball.net/projects/markdown/basics/"} enabled."
    out += " #{extra_text}" if extra_text
    out + ")"
    out.html_safe
  end

  def rpx_embed_code
    RPXNow.embed_code('crantastic',
                      rpx_token_session_url +
                      "#{'?return_to='+params[:return_to] if params[:return_to]}").html_safe
  end

end
