# == Schema Information
# Schema version: 20090615150957
#
# Table name: review
#
#  id            :integer         not null, primary key
#  package_id    :integer
#  user_id       :integer
#  review        :text
#  title         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  version_id    :integer
#  cached_rating :integer
#

class Review < ActiveRecord::Base

  belongs_to :user
  belongs_to :package
  belongs_to :version

  fires :new_review, :on                => :create,
                     :actor             => :user,
                     :secondary_subject => :package

  default_scope :order => "created_at DESC" # Latest first
  named_scope :recent, :limit => 10, :include => [:user, :package]

  before_validation :strip_title_and_review # NOTE: consider before_save
  before_create :cache_rating

  validates_existence_of :package_id
  validates_existence_of :user_id

  validates_length_of :title, :in => 3..255,
                      :message => "(Brief Summary) is too short (minimum is 3 characters)"
  validates_length_of :review, :minimum => 3

  def description
    [title, review].join(". ")
  end

  ###
  # Returns the author's rating of the package at the time the review was
  # written. Returns nil if no rating was given.
  #
  # @return [Fixnum, nil]
  def rating
    cached_rating
  end

  private
  def strip_title_and_review
    self.title.strip! unless title.blank?
    self.review.strip! unless review.blank?
  end

  def cache_rating
    user_rating = self.user.rating_for(self.package)
    self.cached_rating = user_rating.rating if user_rating
  end

end
