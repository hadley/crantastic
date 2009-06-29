module VersionsHelper

  def package_links(packages)
    packages.collect do |p|
      link_to(p.name, p)
    end.join(", ")
  end

  def version_uses
    ((@version.depends + @version.imports).sort.map do |p|
       link_to p.name, p
     end + @version.suggests.map do |p|
       content_tag(:em, link_to(p.name, p))
     end).join(", ") || "Does not use any package"
  end

end
