class VersionObserver < ActiveRecord::Observer

  # Cache latest version in the package record
  def after_create(version)
    version.package.latest_version = version
    version.package.save # no need to explicitly update updated_at
  end

end
