module VersionsHelper

  def version_uses
    ((@version.depends + @version.imports).sort_by { |i| i.name.downcase }.map do |p|
       link_to p.name, p
     end + @version.suggests.map do |p|
       content_tag(:em, link_to(p.name, p))
     end).join(", ") || "Does not use any package"
  end

end
