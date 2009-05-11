module BillingSystem
  
  def accounts
    Account.active.payment_due.each do |account| 
      amount = account.balance
      if account.charge_balance 
        BillingMailer.charge_success(account)
      else
        BillingMailer.charge_failure(account,amount)        
      end
    end
  end
  
  def hostings
    Hosting.active.charge_due.each { |hosting| hosting.charge }
    
  end
end