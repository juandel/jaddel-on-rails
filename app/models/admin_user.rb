require 'digest/sha1'
class AdminUser < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :hashed_password, :username, :salt, :password
  #set_table_name("admin_users")

  attr_accessor :password

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

  # validates_presence_of :first_name
  # validates_length_of :first_name, :maximum => 25
  # validates_presence_of :last_name
  # validates_length_of :last_name, :maximum => 50
  # validates_presence_of :username
  # validates_length_of :username, :within => 8..25
  # validates_uniqueness_of :username
  # validates_presence_of :email
  # validates_length_of :email, :maximum => 100
  # validates_format_of :email, :with => EMAIL_REGEX
  # validates_confirmation_of :email 

  validates :first_name, :presence => true, :length => {:maximum => 25}
  validates :last_name, :presence => true, :length => {:maximum => 50}
  validates :username, :uniqueness => true, :length => {:within => 4..25}
  validates :email, :presence => true, :length => {:maximum => 100}, :format => EMAIL_REGEX, :confirmation =>true
  #only on create, so other attributes of this can be changed when editing.
  validates_length_of :password, :within => 8..25, :on => :create


  has_and_belongs_to_many :pages
  has_many :section_edits
  has_many :sections, :through => :section_edits
 
  before_save :create_hashed_password
  after_save :clear_password


  scope :named, lambda {|first,last| where(:first_name => first, :last_name => last)}
  scope :sorted, order("admin_users.last_name ASC, admin_users.first_name ASC")

  def name
    "#{first_name} #{last_name}"    
  end

  def self.authenticate(username="", password="")
    user =AdminUser.find_by_username(username)
    if user && user.password_match?(password)
      return user
    else
      return false      
    end
  end

  #the same password string with the same hash method and salt
  #should always generate the same hashed_password.
  
  def password_match?(password="")
    hashed_password == AdminUser.hash_with_salt(password, salt)    
  end

  def self.make_salt(username="")
    Digest::SHA1.hexdigest("Use #{username} with #{Time.now} to make salt")
  end

  def self.hash_with_salt(password="", salt="")
    Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
  end

  private

  def create_hashed_password
    #Whenever :password hasa value hashing is needed. 
    unless password.blank?
      #always use "self" when assigning values
      self.salt = AdminUser.make_salt(username) if salt.blank?
      self.hashed_password = AdminUser.hash_with_salt(password, salt)
    end
  end

  def clear_password
    #for security and b/c hashing is not needed
    self.password = nil
  end
end
