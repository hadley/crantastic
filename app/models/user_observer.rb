class UserObserver < ActiveRecord::Observer
  def after_create(user)
    # Don't deliver a signup notification if the user signed up via RPX.
    # This is not needed since we the already know they have a valid e-mail
    # address. We assume that RPX people has blank passwords. (Technically,
    # its currently possible to get a blank password if you disable JS and
    # sign up without filling in the password. Thats the users own fault,
    # though.. shouldnt be a problem.)
    UserMailer.deliver_signup_notification(user) unless user.password.blank?
  end

  def after_save(user)
    UserMailer.deliver_activation(user) if user.pending?
  end
end
