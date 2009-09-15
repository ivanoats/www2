module Chargeable
  #include ActiveRecord::Callbacks
  
  def self.included(base) #:nodoc:
    base.extend Chargeable::ClassMethods
  end

  module ClassMethods
    
  end
  
  #before_create :initialize_next_charge, :unless => Proc.new { |a| a.attribute_present?("next_charge_on") }
  
  
  def cost
    self.product.cost 
  end
  
  def period
    case recurring_month
    when 12
      1.year # 1.year != 12.months
    else
      recurring_month.months
    end
  end
  
  def period_in_words
    case recurring_month
    when 12
      'yearly'
    when 1
      'monthly'
    when 0
      "once"
    else
      "every #{recurring_month} months"
    end
  end
  
  def recurring_month
    self.product.recurring_month
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
  
protected
  def initialize_next_charge
    self.next_charge_on = Time.now + self.period
  end
end
