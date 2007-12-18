class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    = 'Please activate your new crantastic account'
  
    @body[:code] = user.activation_code
  end
  
  def activation(user)
    setup_email(user)
    @subject    = 'Your crantastic account has been activated!'
  end
  
  protected
    def setup_email(user)
      default_url_options[:host] = "crantastic.org"
      
      @recipients  = user.email
      @from        = "Hadley Wickham <cranatic@gmail.com>"
      @sent_on     = Time.now
      body[:user] = user
    end
end
