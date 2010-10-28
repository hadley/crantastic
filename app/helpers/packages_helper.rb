module PackagesHelper

  def select_rating(aspect="overall")
    enabled = logged_in? # Disable the form elements if the user isn't logged in
    output = [ tag(:input, :type => "hidden", :name => "aspect", :value => aspect) ]

    1.upto(5) do |i|
      opts = {:type => "radio", :class => "starselect", :value => i.to_s, :name => "rating"}
      opts.merge!({:disabled => "disabled"}) if enabled != true
      opts.merge!({:checked => "checked"}) if i == @package.average_rating(aspect)
      output << tag(:input, opts)
    end
    content_tag(:div, output.join.html_safe)
  end

  ###
  # Helper for displaying "Package (version)"
  def package_version(pkg, version=pkg.latest, link_to_pkg=true, klass="version")
    out = link_to_pkg ? link_to(pkg.name, pkg) : pkg.name
    if version
      (out += " ".html_safe + content_tag(:span, "(#{version})", :class => klass))
    end
    out.html_safe
  end

  def tag_list
    out = ""
    @package.tags.each_with_index do |tag,i|
      out += content_tag("li",
                         link_to(h(tag), tag, :class => tag.type.to_s.underscore))
    end
    out.html_safe
  end

  def rating(pkg)
    pkg.rating_count.zero? ? "" : "#{pkg.average_rating}/5"
  end

end
