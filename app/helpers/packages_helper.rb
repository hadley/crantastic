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

end
