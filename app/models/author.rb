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

  # Note that one user can have multiple author identities, but
  # an author should only have one user.
  has_one :author_identity, :dependent => :destroy
  has_one :user, :through => :author_identity

  has_many :maintained_versions, :class_name => "Version",
                                 :foreign_key => :maintainer_id,
                                 :order => "LOWER(name) ASC, id DESC"
  has_many :packages, :through => :versions, :uniq => true

  default_scope :order => "LOWER(name)"

  validates_uniqueness_of :email, :scope => :name,
                                  :case_sensitive => false, :allow_nil => true
  validates_length_of :name, :in => 2..255
  validates_length_of :email, :in => 0..255, :allow_nil => true

  def self.find_or_create(name = nil, email = nil)
    author = email.nil? ? nil : Author.find_by_email(email)
    author = Author.find_by_name(name) unless author
    author.nil? ? Author.create(:name => name, :email => email) : author
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

  def latest_versions
    # The collect call picks the first element out of each grouped array.
    # This relies on the default ordering of the version-association.
    # I guess this could be done more efficiently in pure SQL.
    self.versions.group_by { |v| v.package_id }.values.collect { |a| a.first }
  end

end
