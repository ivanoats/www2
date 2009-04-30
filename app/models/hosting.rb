class Hosting < ActiveRecord::Base
  include AASM

  belongs_to :account
  belongs_to :server
  has_many :add_ons
  has_many :charges, :as => :chargable
  has_one :domain #maybe
  
  named_scope :active, :conditions => ["state = ?",'active']
  named_scope :visible, :conditions => {'state' => ['ordered', 'active', 'suspended']}
  named_scope :charge_due, :conditions => ['last_charge_on IS NULL or (charge_period = ? and last_charge_on < SUBDATE(CURDATE(),INTERVAL 1 MONTH)) or (charge_period = ? and last_charge_on < SUBDATE(CURDATE(),INTERVAL 1 YEAR))','monthly','yearly']
  
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
    self.last_charge_on + self.charge_period < (Time.today + 1.day).at_beginning_of_day
  end
  
  def next_charge
    self.last_charge_on + (self.charge_period == "yearly" ? 1.year : 1.month)
  end
  
  def charge
    Hosting.transaction do
      #prevent charge time creeping forward each period
      charge_time = (DateTime.now - next_charge < 1.day) ? next_charge : DateTime.now
      self.account.charges.create(:amount => self.cost, :chargable => self)
      self.update_attribute(:last_charge_on, charge_time)
      self.account.update_attribute(:balance, self.account.balance - self.cost)
    end
  end
  
  def cost
    #TODO build cost from add_ons
    10
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

end
