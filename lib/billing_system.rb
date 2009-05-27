module BillingSystem
  
  def accounts
    Account.active.due.each do |account| 
      amount = account.balance
      if account.charge_balance 
        BillingMailer.deliver_charge_success(account, account.payments.last)
      else
        BillingMailer.deliver_charge_failure(account,amount)        
      end
    end
    
    Account.active.overdue.each do |account|
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
  
  def hostings
    Hosting.active.due.each { |hosting| hosting.charge }
    
  end
end