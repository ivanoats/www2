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

  def hostings
    #TODO active/expired accounts 
    Hosting.all.each { |hosting| hosting.charge if hosting.should_charge? }
  end
  
  def accounts
    Account.all.each { |account| account.check_subscription }
  end
  
  #these should also eventually handle mailings
end

