require 'machinist/active_record'
require "sham"

Sham.name { (1..10).map { ('a'..'z').to_a.rand }.join }
Sham.login { (1..10).map { ('a'..'z').to_a.rand }.join }
Sham.real_name  { Faker::Name.name }
Sham.email { Faker::Internet.email }
Sham.title { Faker::Lorem.sentence }
Sham.body  { Faker::Lorem.paragraph }

User.blueprint do
  login
  email
  password { "test" }
  password_confirmation { "test" }
end

Version.blueprint do
  name
  version { "1.0" }
  package { Package.make }
end

Package.blueprint do
  name
end

Author.blueprint do
  name { Sham.real_name }
  email
end

Review.blueprint do
  rating { (1..5).to_a.rand }
end
