require 'digest/sha1'

# Users start as passive until they login or register
class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  aasm_initial_state :passive

  aasm_event :register_from_checkout do
    transitions :from => :passive, :to => :active
  end

  before_create :make_activation_code

  # Validations
  validates_presence_of :login, :if => Proc.new {|user| user.not_using_openid? && !user.login.blank?}
  validates_length_of :login, :within => 3..40, :if => Proc.new {|user| user.not_using_openid? && !user.login.blank?}
  validates_uniqueness_of :login, :case_sensitive => false, :if => Proc.new {|user| user.not_using_openid? && !user.login.blank?}
  validates_format_of :login, :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD, :if => Proc.new {|user| user.not_using_openid? && !user.login.blank?}
  validates_format_of :name, :with => RE_NAME_OK, :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of :name, :maximum => 100
  validates_presence_of :email, :if => :not_using_openid?
  validates_length_of :email, :within => 6..100, :if => :not_using_openid?
  validates_uniqueness_of :email, :case_sensitive => false, :if => :not_using_openid?
  validates_format_of :email, :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD, :if => :not_using_openid?
  validates_uniqueness_of :identity_url, :unless => :not_using_openid?
  validate :normalize_identity_url
  
  # Relationships
  has_many :articles
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :accounts

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :identity_url, :profile

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = User.active.find(:first, :conditions => ["(login = ? || email = ?) && enabled = ?", login, login, true])    
    u && u.authenticated?(password) ? u : nil
  end
  
  # Check if a user has a role.
  def has_role?(role)
    list ||= self.roles.map(&:name)
    list.include?(role.to_s) || list.include?('Administrator')
  end
  
  # Not using open id
  def not_using_openid?
    identity_url.blank?
  end
  
  # Overwrite password_required for open id
  def password_required?
    return false if passive?
    
    new_record? ? not_using_openid? && (crypted_password.blank? || !password.blank?)  : !password.blank?
  end
  
  def username
    return self.name unless self.name.blank?
    return self.login unless self.login.blank?
    return self.email
  end
  
  protected
  
  
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end
  
  def normalize_identity_url
    self.identity_url = OpenIdAuthentication.normalize_url(identity_url) unless not_using_openid?
  rescue URI::InvalidURIError
    errors.add_to_base("Invalid OpenID URL")
  end
end
