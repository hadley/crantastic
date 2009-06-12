Factory.define :user do |u|
  u.login 'John'
  u.email {|a| "#{a.login}@example.com".downcase }
  u.password 'test'
  u.password_confirmation 'test'
end

Factory.define :package do |pkg|
  pkg.name "TestPkg"
end
