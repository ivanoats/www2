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
  
  def generate_password
    self.password = Base64.encode64(Digest::SHA1.digest("#{rand(1<<64)}/#{Time.now.to_f}/#{Process.pid}"))[0..7]
    
  end
  
  def generate_username
    self.username = self.domains.first.name
    self.username.slice!(0,[self.username.rindex('.'),8].min)
    
    
    while !Hosting.find_by_username(self.username).nil?
      self.username.next!
    end  
  end

private
  
  
  def create_cpanel_account
    logger.error "CREATING CPANEL ACCOUNT"
    debugger
    
    #self.server.whm.create_account(:username => self.username, :domain => self.domain)
  end
  
  def suspend_cpanel_account
    logger.error "SUSPENDING CPANEL ACCOUNT"
    debugger
    
    self.server.whm.suspend_account(:user => self.username)
  end
  
  def unsuspend_cpanel_account
    
    self.server.whm.unsuspend_account(:user => self.username)
  end
  
  def delete_cpanel_account
    logger.error "DELETING CPANEL ACCOUNT"
    debugger

    #self.server.whm.terminate_account(:user => self.username)
  end

end
