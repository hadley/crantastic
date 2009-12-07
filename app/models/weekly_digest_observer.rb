# Delivers the weekly digest after it has been created
class WeeklyDigestObserver < ActiveRecord::Observer

  def after_create(digest)
    DigestMailer.deliver_weekly_digest(digest)
  end

end
