Webrat.configure do |config|
  config.mode = :rails
end

module WebratHelpers
  def login_with_valid_credentials
    fill_in "login", :with => "john"
    fill_in "password", :with => "test"
    click_button "login"
  end
end
