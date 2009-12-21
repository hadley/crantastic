# Delivers the weekly digest after it has been created,
# unless no packages or versions have been updated, as
# this indicates an error.
class WeeklyDigestObserver < ActiveRecord::Observer

  def after_create(digest)
    unless digest.packages.empty? && digest.versions.empty?
      DigestMailer.deliver_weekly_digest(digest)
    end
  end

end
