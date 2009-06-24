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
    content_tag(:div, output.join)
  end

  ###
  # Helper for displaying "Package (version)"
  def package_version(pkg, version, link_to_pkg=true)
    out = (link_to_pkg ? link_to(h(pkg.name), pkg) : pkg.name)
    out += " " + content_tag(:span, "(#{h(version)})", :class => "version") if version
    out
  end

  def tag_list
    out = ""
    @package.tags.each_with_index do |tag,i|
      a_class = ""
      if tag.task_view?
        out += content_tag("li",
                           link_to(tag, task_view_path(tag), :class => "task_view"))
      else
        out += content_tag("li",
                           link_to(tag, tag_path(tag)))
      end
    end
    out
  end

end
