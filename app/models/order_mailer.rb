class OrderMailer < ActionMailer::Base

  def complete(order, user)
    setup_email
    subject    "#{APP_CONFIG[:site_name]} Order ##{order.id} Receipt"
    recipients user.email || order.account.default_email
    body[:order] = order
  end
  
  def admin_notification(order)
    setup_email
    subject    "#{APP_CONFIG[:site_name]} New Order ##{order.id} Purchased"
    recipients APP_CONFIG[:admin_email]
    body[:order] = order
  end
  
  def hosting_approved(hosting)
    setup_email
    
    subject "#{APP_CONFIG[:site_name]} website #{hosting.username} is now available"
    recipients hosting.account.default_email
    body[:hosting] = hosting
  end
  
protected

  def setup_email
    @from = APP_CONFIG[:admin_email]
    @subject = "[#{APP_CONFIG[:site_name]}] "
    @sent_on = Time.now
  end

end
