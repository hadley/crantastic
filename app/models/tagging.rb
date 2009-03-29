# == Schema Information
#
# Table name: tagging
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  package_id :integer
#  tag        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tagging < ActiveRecord::Base
  belongs_to :user
  belongs_to :package

  # TODO: this regexp needs to cover more cases
  validates_format_of :tag, :with => /^[^ ].*[a-zA-Z0-9]$/
  validates_length_of :tag, :minimum => 2

  def self.tags
    connection.execute "SELECT DISTINCT tag, count(*) as count FROM tagging GROUP BY tag"
  end
end
