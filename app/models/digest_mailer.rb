class DigestMailer < ActionMailer::Base

  def weekly_digest(digest)
    @recipients   = "r-help@r-project.org"
    @from         = "Hadley Wickham <cranatic@gmail.com>"
    @sent_on      = Time.now
    body[:digest] = digest
  end

end
