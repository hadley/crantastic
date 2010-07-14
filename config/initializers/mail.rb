ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => 'crantastic.org',
  :authentication => :plain,
  :enable_starttls_auto => true,
  :user_name => 'cranatic',
  :password => ENV['GMAIL']
}
