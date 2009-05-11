class BillingWorker < BackgrounDRb::MetaWorker
  set_worker_name :billing_worker
  
  include BillingSystem
  
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
  end
  
  def billing
    logger.info "Starting Billing worker at #{Time.now}"
    hostings
    logger.info "Completed hostings at #{Time.now}"    
    accounts
    logger.info "Billing worker completed at #{Time.now}.  "
  end

end

