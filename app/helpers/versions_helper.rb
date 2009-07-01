module VersionsHelper

  def package_links(packages)
    packages.collect do |p|
      link_to(p.name, p)
    end.join(", ")
  end

  def version_uses
    uses = (@version.uses.map do |p|
              link_to p.name, p
            end + @version.suggests.map do |p|
              content_tag(:em, link_to(p.name, p))
            end).join(", ")
    uses.blank? ? "Does not use any package" : uses
  end

end
