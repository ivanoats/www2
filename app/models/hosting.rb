class Hosting < ActiveRecord::Base
  include AASM

  belongs_to :account
  belongs_to :server
  has_many :add_ons
  has_many :charges, :as => :chargable
  has_one :domain #maybe
  
  belongs_to :product
  
  validates_presence_of :product_id
  
  named_scope :active, :conditions => ["state = ?",'active']
  named_scope :visible, :conditions => {'state' => ['ordered', 'active', 'suspended']}
  named_scope :charge_due, :include => :product, :conditions => ['next_charge_on < CURDATE()']
  
  before_create :set_next_charge, :unless => Proc.new { |a| a.attribute_present?("next_charge_on") }
  
  # '(last_charge_on < SUBDATE(CURDATE(),INTERVAL products.recurring_month MONTH))'
  #(last_charge_on IS NULL and created_at < SUBDATE(CURDATE(),INTERVAL products.recurring_month MONTH)) or 
  
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
    self.next_charge < (Time.today + 1.day).at_beginning_of_day
  end
  
  # def next_charge
  #     (self.last_charge_on || self.created_at) + self.product.recurring_month.months
  #   end
  
  def charge
    Hosting.transaction do
      #prevent charge time creeping forward each period
      charge_time = (DateTime.now - next_charge < 1.day) ? next_charge : DateTime.now
      self.account.charges.create(:amount => self.cost, :chargable => self)
      self.update_attribute(:next_charge_on, Time.now + self.period)
      self.account.update_attribute(:balance, self.account.balance - self.cost)
    end
  end
  
  def cost
    self.product.cost
  end
  
  def period
    case self.product.recurring_month
    when 12
      1.year # 1.year != 12.months
    else
      self.product.recurring_month.months
    end
  end
  
  def period_words
    case product.recurring_month
    when 12
      'yearly'
    when 1
      'monthly'
    else
      "every #{product.recurring_month} months"
    end
  end

private

  def create_cpanel_account
    #TODO create default cpanel_user
    self.update_attribute(:cpanel_user, "testing#{rand(1000)}")
    self.server.whm.create_account(:username => self.cpanel_user, :domain => 'example.com')
  end
  
  def suspend_cpanel_account
    self.server.whm.suspend_account(:user => self.cpanel_user)
  end
  
  def unsuspend_cpanel_account
    self.server.whm.unsuspend_account(:user => self.cpanel_user)
  end
  
  def delete_cpanel_account
    self.server.whm.terminate_account(:user => self.cpanel_user)
  end
  
  def set_next_charge
    self.next_charge_on = Time.now + self.period
  end

end
