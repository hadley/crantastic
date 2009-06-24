class VersionObserver < ActiveRecord::Observer

  def after_create(version)
    # Cache latest version in the package record
    version.package.latest_version = version
    version.package.save # no need to explicitly update updated_at

    # Update the author's updated_at attribute
    if version.maintainer
      version.maintainer.update_attribute(:updated_at, Time.now)
    end
  end

end
