# == Schema Information
# Schema version: 20090613223342
#
# Table name: review
#
#  id         :integer         not null, primary key
#  package_id :integer
#  user_id    :integer
#  rating     :integer
#  review     :text
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  version_id :integer
#

class Review < ActiveRecord::Base

  belongs_to :user
  belongs_to :package
  belongs_to :version

  default_scope :order => "created_at DESC" # Latest first
  named_scope :recent, :limit => 10, :include => [:user, :package]

  before_validation :strip_title_and_review # NOTE: consider before_save

  validates_presence_of :package_id
  validates_presence_of :user_id
  validates_numericality_of :rating, :greater_than => 0, :less_than => 6
  validates_length_of :title, :within => 3..255,
                      :message => "(Brief Summary) is too short (minimum is 3 characters)"
  validates_length_of :review, :minimum => 3

  def description
    [title, review].join(". ")
  end

  private
  def strip_title_and_review
    self.title.strip! unless title.blank?
    self.review.strip! unless review.blank?
  end

end
