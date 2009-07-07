Webrat.configure do |config|
  config.mode = :rails
end

module WebratHelpers
  def login_with_valid_credentials(login = "john", password = "test")
    fill_in "login", :with => login
    fill_in "password", :with => password
    click_button "login"
  end
end
