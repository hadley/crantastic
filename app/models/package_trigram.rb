# == Schema Information
# Schema version: 20090402200300
#
# Table name: package_trigram
#
#  id         :integer         not null, primary key
#  package_id :integer         not null
#  tg         :string(255)     not null
#  score      :integer         default(1), not null
#

class PackageTrigram < ActiveRecord::Base
end
