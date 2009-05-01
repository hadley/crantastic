Factory.define :user do |u|
  u.login 'John'
  u.email {|a| "#{a.login}@example.com".downcase }
  u.password 'test'
  u.password_confirmation 'test'
end
