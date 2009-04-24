class BillingWorker < BackgrounDRb::MetaWorker
  set_worker_name :billing_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def billing
    logger.info "Starting Billing worker at #{Time.now}"
    hostings
    logger.info "Completed hostings at #{Time.now}"    
    accounts
    logger.info "Completed accounts at #{Time.now}"
    logger.info "Billing worker completed.  "
  end

private

  
  def accounts
    Account.active.payment_due.each do |account| 
      balance = account.balance
      if account.charge_balance 
        BillingMailer.charge_success(account,balance)
      else
        BillingMailer.charge_failure(account,balance)        
      end
    end
  end

  def hostings
    Hosting.active.charge_due.each { |hosting| hosting.charge }
  end
end

