class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    subject    = 'Please activate your new crantastic account'
  
    body[:code] = user.activation_code
  end
  
  def activation(user)
    setup_email(user)
    subject    = 'Your crantastic account has been activated!'
  end
  
  protected
    def setup_email(user)
      recipients  = user.email
      from        = "Hadley Wickham <admin@crantastic.org>"
      sent_on     = Time.now
      body[:user] = user
    end
end