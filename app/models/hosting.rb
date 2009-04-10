class Hosting < ActiveRecord::Base
  belongs_to :account
  has_many :add_ons
  
  #has_one :domain #maybe

  def should_charge?
    self.last_charge_on + self.charge_period < (Time.today + 1.day).at_beginning_of_day
  end
  
  def charge
    self.update_attribute(:last_charge_on, Date.today)
    self.account.update_attribute(:balance, self.account.balance - self.cost)
  end
  
  def cost
    #TODO build cost from add_ons
    10
  end

end
