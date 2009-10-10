# == Schema Information
# Schema version: 20090615123240
#
# Table name: package_rating
#
#  id         :integer         not null, primary key
#  package_id :integer
#  user_id    :integer
#  rating     :integer
#  created_at :datetime
#  updated_at :datetime
#  aspect     :string(25)      default("overall"), not null
#

class PackageRating < ActiveRecord::Base

  belongs_to :user, :touch => true
  belongs_to :package, :touch => true

  fires :new_package_rating, :on                => [:create, :update],
                             :actor             => :user,
                             :secondary_subject => :package

  validates_existence_of :package_id
  validates_existence_of :user_id
  # users can only have one active vote per package:
  validates_uniqueness_of :user_id, :scope => [:package_id, :aspect]
  validates_format_of :rating, :with => /^[1-5]$/
  validates_inclusion_of :aspect, :in => %w(overall documentation)

  # Calculates the average rating for a given package
  def self.calculate_average(package_id, aspect="overall")
    average('rating', :conditions => ["aspect = ? AND package_id = ?",
                                      aspect, package_id]).to_f
  end

  def to_s
    rating.to_s
  end

end
