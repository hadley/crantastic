class VersionObserver < ActiveRecord::Observer

  def after_create(version)
    version.description = "" if version.description.nil?

    # Cache latest version and description in the package record
    version.package.latest_version = version
    version.package.description = version.description

    # Store associations for depends, enhances, suggests, and authors
    version.required_packages = version.parse_depends
    version.enhanced_packages = version.parse_enhances
    version.suggested_packages = version.parse_suggests
    # version.authors = (version.parse_authors + [version.maintainer]).compact.uniq
    version.authors = [version.maintainer].compact

    version.package.save! # no need to explicitly update updated_at

    # Update the author's updated_at attribute
    unless version.authors.empty?
      version.authors.each(&:touch)
    end

    # Create/Update Priority taggings
    if version.priority.blank?
      # Destroy removed priorities, if any
      version.package.tags.type("Priority").each do |removed_priority|
        Tagging.delete_all(["package_id = ? AND tag_id = ?",
                            version.package.id, removed_priority.id])
      end
    else
      priorities = version.package.tags.type("Priority")
      new_priorities = version.priority.split(",").collect { |p| p.strip.capitalize }

      (priorities.map(&:name) - new_priorities).each do |removed_priority|
        Tagging.delete_all(["package_id = ? AND tag_id = ?",
                            version.package.id,
                            Priority.find_by_name(removed_priority).id])
      end

      (new_priorities - priorities.map(&:name)).each do |added_priority|
        version.package.taggings <<
          Tagging.new(:tag => Priority.find_or_create_by_name(added_priority),
                      :user_id => 146) # 146 = crantastic system user
      end
    end

    # Create timeline event if this wasn't the first version upgrade for the pkg
    return if version.package.versions.count == 1
    TimelineEvent.create!(:event_type => "new_version",
                          :subject => version,
                          :secondary_subject => version.package)
  end

end
