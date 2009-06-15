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

# TODO: validate existence of version_id for new records
class Review < ActiveRecord::Base

  belongs_to :user
  belongs_to :package
  belongs_to :version

  default_scope :order => "created_at DESC" # Latest first
  named_scope :recent, :limit => 10, :include => [:user, :package]

  before_validation :strip_title_and_review # NOTE: consider before_save
  before_create :cache_rating

  validates_presence_of :package_id
  validates_presence_of :user_id
  validates_length_of :title, :within => 3..255,
                      :message => "(Brief Summary) is too short (minimum is 3 characters)"
  validates_length_of :review, :minimum => 3

  def description
    [title, review].join(". ")
  end

  ###
  # Returns the rating given by the review author, if he has rated at all.
  #
  # @return [Fixnum, nil]
  def rating#(aspect="overall")
    #self.user.rating_for(self.package, aspect)
    cached_rating
  end

  private
  def strip_title_and_review
    self.title.strip! unless title.blank?
    self.review.strip! unless review.blank?
  end

  def cache_rating
    self.cached_rating = self.user.rating_for(self.package).rating
  end

end
