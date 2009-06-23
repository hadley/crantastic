# == Schema Information
#
# Table name: author
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Author < ActiveRecord::Base
  is_gravtastic # Enables the Gravtastic plugin for the Author model

  has_many :versions, :foreign_key => :maintainer_id, :order => :name

  default_scope :order => "LOWER(name)"

  validates_uniqueness_of :email, :scope => :name,
                                  :case_sensitive => false, :allow_nil => true
  validates_length_of :name, :in => 2..255
  validates_length_of :email, :in => 0..255, :allow_nil => true

  def self.find_or_create(name = nil, email = nil)
    author = Author.find_by_email(email) || Author.find_by_name(name)

    return author if author

    Author.create(:name => name, :email => email)
  end

  # Input is mainly from the "Maintainer"-field in CRAN's DESCRIPTION
  # files. E.g. "Christian Buchta <christian.buchta at wu-wien.ac.at>".
  # E-mail address is not guaranteed to be valid, as can be seen above.
  #
  # @return [Author] An Author-object corresponding to the input string
  def self.new_from_string(string)
    return Author.find_or_create_by_name("Unknown") if string.blank?

    name, email = string.mb_chars.split(/[<>]/).map(&:strip)
    if name =~ /@/
      email = name
      name = nil
    end

    email.downcase! unless email.blank? # NOTE: is this necessary?

    Author.find_or_create(name, email)
  end

  def to_s
    self.name
  end
end
