class BillingSystem
  
  def self.due_accounts
    Account.active.due
  end
  
  def self.overdue_accounts
    Account.active.overdue
  end
  
  def self.due_hostings
    Hosting.active.due
  end
  
  def self.due_domains
    Domain.active.due
  end
  
  def self.due_addons
    AddOn.active.due
  end
  
  def self.charge_accounts
    due_accounts.each do |account| 
      amount = account.balance
      if account.charge_balance 
        BillingMailer.deliver_charge_success(account, account.payments.last)
      else
        BillingMailer.deliver_charge_failure(account,amount)        
      end
    end
    
    overdue_accounts.each do |account|
      amount = account.balance
      if account.charge_balance
        BillingMailer.deliver_charge_success(account, account.payments.last)
      else
        days_overdue = Date.today - account.next_payment_on
        case days_overdue
        when 1..4
          BillingMailer.deliver_charge_failure(account,amount)   
        when 5
          account.hostings.each { |hosting| hosting.suspend! }
        end
      end
    end
    
  end
  
  def self.charge_all
    charge_hostings
    charge_domains
    charge_addons
    
    charge_accounts
    
  end
  
  def self.charge_hostings
    due_hostings.each { |hosting| hosting.charge }
  end
  
  def self.charge_domains
    due_domains.each { |domain| domain.charge }
  end
  
  def self.charge_addons
    due_addons.each { |add_on| add_on.charge }
  end
end