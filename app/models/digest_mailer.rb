class DigestMailer < ActionMailer::Base

  def weekly_digest(digest)
    @recipients   = "r-help@r-project.org"
    @from         = "Hadley Wickham <cranatic@gmail.com>"
    @sent_on      = Time.now
    @subject      = "CRAN (and crantastic) updates this week"
    @body[:digest] = digest
  end

end
