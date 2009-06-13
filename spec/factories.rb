Factory.define :user do |u|
  u.login 'John'
  u.email {|a| "#{a.login}@example.com".downcase }
  u.password 'test'
  u.password_confirmation 'test'
end

Factory.define :version do |v|
  v.version "1.0"
  v.name "Alpha"
  v.association :package, :factory => :package
end

Factory.define :package do |pkg|
  pkg.name "TestPkg"
end

Factory.define :author do |author|
  author.name "John"
end
