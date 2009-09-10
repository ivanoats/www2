class Hosting < ActiveRecord::Base
  include AASM

  belongs_to :account
  belongs_to :server
  has_many :add_ons
  has_many :charges, :as => :chargable
  
  belongs_to :product
  belongs_to :whmaphostingorder
  
  validates_presence_of :product_id
  validates_presence_of :username
  validates_presence_of :password
  validates_presence_of :domain
  
  validates_length_of :username, :maximum => 8
  validates_uniqueness_of :username

  named_scope :visible, :conditions => {'state' => ['ordered', 'active', 'suspended']}
  named_scope :due, :include => :product, :conditions => ['next_charge_on <= CURDATE()']
  
  before_create :set_next_charge, :unless => Proc.new { |a| a.attribute_present?("next_charge_on") }
  
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
    

  def should_charge?
    self.next_charge_on < (Time.today + 1.day).at_beginning_of_day
  end
  
  def charge
    Hosting.transaction do
      #prevent charge time creeping forward each period
      charge_time = (DateTime.now - next_charge_on < 1.day) ? next_charge_on : DateTime.now
      self.account.charges.create(:amount => self.cost, :chargable => self)
      self.update_attribute(:next_charge_on, Time.now + self.period)
      self.account.update_attribute(:balance, self.account.balance - self.cost)
    end
  end
  
  def cost
    self.custom_cost || self.product.cost 
  end
  
  def period
    case recurring_month
    when 12
      1.year # 1.year != 12.months
    else
      recurring_month.months
    end
  end
  
  def recurring_month
    self.custom_recurring_month || self.product.recurring_month
  end
  
  def period_in_words
    case recurring_month
    when 12
      'yearly'
    when 1
      'monthly'
    else
      "every #{recurring_month} months"
    end
  end

  def name
    "Web Hosting #{self.username}"
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
  
  def set_next_charge
    self.next_charge_on = Time.now + self.period
  end

end
