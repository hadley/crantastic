require 'machinist/active_record'
require "sham"

Sham.name { (1..10).map { ('a'..'z').to_a.rand }.join }
Sham.login { (1..10).map { ('a'..'z').to_a.rand }.join }
Sham.full_name  { Faker::Name.name }
Sham.email { Faker::Internet.email }
Sham.url { "http://" + Faker::Internet.domain_name }
Sham.title { Faker::Lorem.sentence }
Sham.body  { Faker::Lorem.paragraph }
Sham.description { Sham.body }
Sham.rating(:unique => false) { (1..5).to_a.rand }

User.blueprint do
  login
  email
  password { "test" }
  password_confirmation { "test" }
  tos { true }
end

Version.blueprint do
  name
  version { "1.0" }
  imports { "xtable" }
  enhances { "stats" }
  suggests { "ggplot" }
  url

  package
  maintainer { Author.make }
end

Package.blueprint do
  name
end

PackageRating.blueprint do
  rating
  aspect { "overall" }

  package
  user
end

Author.blueprint do
  name { Sham.full_name }
  email
end

Review.blueprint do
  title
  review { Sham.body }
  cached_rating { Sham.rating }

  package
  user
end

Tag.blueprint do
  name
  full_name
  description
end

TaskView.blueprint do
  name
  full_name
  description
  version { "2009-05-09" }
end

Tagging.blueprint do
  tag
  user
  package
end

TimelineEvent.blueprint do
end

def make_timeline_event_for_version(version = Version.make)
  TimelineEvent.make(:subject => version,
                     :secondary_subject => version.package,
                     :event_type => "new_version")
end
