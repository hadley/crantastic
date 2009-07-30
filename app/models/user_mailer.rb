class UserMailer < ActionMailer::Base
  def activation_instructions(user)
    setup_email(user)
    @subject     = 'Please activate your new crantastic account'
    @body[:activation_url] = activate_url(user.perishable_token)
  end

  def activation_confirmation(user)
    setup_email(user)
    @subject    = 'Your crantastic account has been activated!'
  end

  def password_reset_instructions(user)
    setup_email(user)
    @subject = "Password Reset Instructions"
    @body[:edit_password_reset_url] = edit_password_reset_url(user.perishable_token)
  end

  protected
    def setup_email(user)
      default_url_options[:host] = APP_CONFIG[:site_domain]

      @recipients = user.email
      @from       = "Hadley Wickham <cranatic@gmail.com>"
      @sent_on    = Time.now
      body[:user] = user
    end
end
