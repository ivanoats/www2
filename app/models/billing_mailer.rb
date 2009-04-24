class BillingMailer < ActionMailer::Base
  
  def charge_success(account,amount)
    @subject    = 'Sustainablewebsites Payment Receipt'
    payment = account.payments.last
    @body = payment.receipt
    @recipients = account.email
    @bcc = 'support@sustainablewebsites.com'
    @from       = 'support@sustainablewebsites.com'
    @headers["Sender"]  =  "sustainablewebsites.com"    
  end
  
  def charge_failure(account,amount)
    @subject    = 'Sustainablewebsites Payment Failed'
    @body["account"] = account
    @body["amount"] = amount
    @recipients = account.email
    @bcc = 'support@sustainablewebsites.com'
    @from = 'support@sustainablewebsites.com'
    @headers["Sender"]  =  "sustainablewebsites.com"    
  end

end
