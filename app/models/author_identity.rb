# == Schema Information
#
# Table name: author_identity
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)      not null
#  author_id  :integer(4)      not null
#  created_at :datetime
#  updated_at :datetime
#

# Join table for identifying user accounts with authors
class AuthorIdentity < ActiveRecord::Base

  belongs_to :author
  belongs_to :user

  # Only one user can be identified as each author:
  validates_uniqueness_of :author_id

end
