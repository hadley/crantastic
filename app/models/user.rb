# == Schema Information
#
# Table name: user
#
#  id                        :integer         not null, primary key
#  login                     :string(255)
#  email                     :string(255)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  activation_code           :string(40)
#  activated_at              :datetime
#

require 'digest/sha1'
class User < ActiveRecord::Base
  include RFC822
  is_gravtastic # Enables the Gravtastic plugin for the User model

  has_many :reviews
  has_many :taggings
  has_many :identifiers, :class_name => "UserIdentifier"

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_format_of       :email,    :with => EmailAddress
  validates_uniqueness_of   :login, :email, :case_sensitive => false

  before_save :encrypt_password
  before_create :make_activation_code
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  # Returns true if the user has just been activated.
  def pending?
    @activated
  end

  # Add an identifier for RPX for this user account
  def add_identifier(identifier)
    self.identifiers << UserIdentifier.create!(:user_id => self.id, :identifier => identifier)
    RPXNow.map(identifier, self.id.to_s, ENV['RPX_API_KEY']) # Map the PK
    self.activate unless self.active?
  end

  # Rates a package, discarding the users previous rating in the process
  # TODO should check for valid package id, probably in the PackageRating model
  #
  # @param [Fixnum, Package] package
  # @param [Fixnum] rating
  # @return [PackageRating]
  def rate!(package, rating)
    package = package.id if package.kind_of?(Package)
    r = rating_for(package)
    r.destroy if r
    PackageRating.create!(:package_id => package, :user_id => self.id, :rating => rating)
  end

  # This users' rating for a package
  #
  # @param [Fixnum] package The primary key (id) of the package to rate
  # @return [PackageRating] The PackageRating object
  def rating_for(package)
    PackageRating.find(:first,
                       :conditions => {:package_id => package,
                                       :user_id => self.id})
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    # We explicitly don't allow logins with blank passwords.
    return nil if password.blank?
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login]
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  protected
    # before filter
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def password_required?
      # Not required since we allow OpenID etc. But we don't allow regular
      # logins with blank passwords.
      false
    end

    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join)[1..10]
    end

end
