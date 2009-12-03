class Hosting < ActiveRecord::Base
  include AASM
  include Chargeable
  before_create :initialize_next_charge, :unless => Proc.new { |a| a.attribute_present?("next_charge_on") }
  
  belongs_to :account
  belongs_to :server
  has_many :add_ons
  has_many :domains
  
  has_many :charges, :as => :chargable
  
  belongs_to :product
  belongs_to :whmaphostingorder
  
  validates_presence_of :product_id
  validates_presence_of :username
  validates_presence_of :password
  
  validates_length_of :username, :maximum => 8
  validates_uniqueness_of :username

  named_scope :visible, :conditions => {'state' => ['ordered', 'active', 'suspended']}
  named_scope :due, :include => :product, :conditions => ['next_charge_on <= CURDATE()']
  
  aasm_column :state
  aasm_initial_state :ordered
  aasm_state :ordered
  aasm_state :active, :enter => :create_cpanel_account
  aasm_state :suspended, :enter => :suspend_cpanel_account, :exit => :unsuspend_cpanel_account
  aasm_state :deleted, :enter => :delete_cpanel_account

    
  aasm_event :activate do
    transitions :from => :ordered, :to => :active, :guard => Proc.new {|u| !u.server.nil? }
  end
  
  aasm_event :suspend do
    transitions :from => [:ordered, :active], :to => :suspended
  end
  
  aasm_event :delete do
    transitions :from => [:ordered, :active, :suspended], :to => :deleted
  end

  aasm_event :unsuspend do
    transitions :from => :suspended, :to => :active
  end

  def name
    "Web Hosting #{self.username}"
  end
  
  def domain
    self.domains.first.name
  rescue
    "No Default Domain"
  end
  
  def generate_password
    self.password = Base64.encode64(Digest::SHA1.digest("#{rand(1<<64)}/#{Time.now.to_f}/#{Process.pid}"))[0..7]
    
  end
  
  def generate_username
    #base the username on the first 8 characters of the domain name
    self.username = self.domains.first.name.dup
    self.username = self.username.slice(0,[self.username.rindex('.'),8].min)
    
    #convert from 'greenhut' to 'greenhu1'
    self.username = self.username[0,7] + "1" if Hosting.find_by_username(self.username)
    
    #increase last character until we find a unique name
    while !Hosting.find_by_username(self.username).nil?
      self.username.next!
    end  
  end


  def create_cpanel_account
    
    self.server.whm.create_account(:username => self.username, :domain => self.domain)    
    OrderMailer.deliver_hosting_approved(self)
  end
  
  def suspend_cpanel_account
    self.server.whm.suspend_account(:user => self.username)
  end
  
  def unsuspend_cpanel_account
    self.server.whm.unsuspend_account(:user => self.username)
  end
  
  def delete_cpanel_account
    
    self.server.whm.terminate_account(:user => self.username)
  end

end
