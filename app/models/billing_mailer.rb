class BillingMailer < ActionMailer::Base
  
  def charge_success(account)
    @subject    = 'Sustainablewebsites Payment Receipt'
    @body["account"]       = account
    @recipients = account.email
    @bcc = 'support@sustainablewebsites.com'
    @from       = 'support@sustainablewebsites.com'
    @headers["Sender"]  =  "sustainablewebsites.com"    
  end
  
  def charge_failure(account)
    @subject    = 'Sustainablewebsites Payment Failed'
    @body["account"]       = account
    @recipients = account.email
    @bcc = 'support@sustainablewebsites.com'
    @from       = 'support@sustainablewebsites.com'
    @headers["Sender"]  =  "sustainablewebsites.com"    
  end

end
