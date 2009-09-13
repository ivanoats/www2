# receives paypal emails and marks invoices paid in the whmap billing database
class PayPalPayments < ActionMailer::Base
  # finds the value (text) after the needle(key) in a haystack, until the end character
  def self.find_after_until(haystack, needle, end_char )
    
    # handle edge case where customer didn't fill out domain name in paypal renewal form
    # because normal method will error because there is no [] around domain name
    if haystack == "domain_name.com" 
      return "domain_name.com"
    end
    
    # normal find_after_until method
    start_position = haystack.index(needle) + needle.length
    end_position = haystack.index(end_char, start_position) - 1
    haystack[start_position..end_position]
  end # find_after_until
  
  def self.receive(email)
    email_parsed = TMail::Mail.parse(email)
    email_body = email_parsed.parts[0].body
    
    # if email_parsed.messageid is not in PayPalEmailLogs table and it's a payment notification email
    if PayPalEmailLogs.find_by_messageid(email_parsed.messageid) == nil && email_parsed.subject.downcase == "you have received a subscription payment" then
      # read payment info from email. amount, txn_id (paypal subscription number)
      amount =  find_after_until(email_body,"Amount: $"," ").to_i
      subscription_number = find_after_until(email_body,"Subscription Number: ","\n")
      domain_name = find_after_until(find_after_until(email_body,"Subscription Name: ", "\n"), "[","]")
      user_email = find_after_until(email_body,"Email: ","\n")
      
      # associate it to a order id (oid) or user id (uid)
      order = Whmaphostingorder.find_by_txn_id(subscription_number)
      if domain_name != "domain_name.com" && order.nil?
        order = Whmaphostingorder.find_by_domain_name(domain_name)
      end
      if order.nil?
        user = Whmapuser.find_by_email(user_email)
        order = Whmaphostingorder.find_by_uid(user)
      end
      if order.nil?
        raise( "Billing Warning: failed to find any valid info in paypal email: " + email_body )
      end
       
      # find an invoice for that user (or order) around the date of the email
      # find all unpaid invoices for that user in the order
      unpaid_invoices = Whmapinvoice.find(:all, :conditions => { :uid => order.uid, :status => 0 } )
      
      # if there's only one unpaid invoice, mark that invoice as paid
      if unpaid_invoices.size == 1
        unpaid_invoices.first.status = 1
        unpaid_invoices.first.date_paid = Time.now.to_i
        # record email_parsed.messageid in PayPalEmailLog
        unpaid_invoices.first.save!
      else
      # if there's more than one unpaid invoice, mark the invoice that's in the same month as paid
        marked_as_paid = false
        unpaid_invoices.each do |invoice|
          # figger out month of invoice
          # if it matches the email date, mark it as paid, and exit loop
          if Time.at(invoice.due_date).month == email_parsed.date.month
            invoice.status = 1
            invoice.date_paid = Time.now.to_i
            invoice.save!
            marked_as_paid = true
            # record email_parsed.messageid in PayPalEmailLog
            break
          end # if
        end #each 
        # if i looped through all, didn't mark any as paid is false, and last is still unpaid, make an error
        unless marked_as_paid
          if ( unpaid_invoices.size == 0 || unpaid_invoices.last.status == 0  )
            debugger
            error_text = "[Billing Warning] : couldn't match paypal email with outstanding invoice for uid: " + order.uid.to_s +  "\n" + ", domain name: " + order.domain_name + "\n" + "Date: " + email_parsed.date.strftime('%Y-%m-%d') + "\n" + email_body
            logger.warn(error_text)
            # email billing with error details and email body?
          end
        end #marked an invoice as paid already
      end #unpaid invoices
      
    end # end if email is a subscription payment email  
  end # self.receive
  
end
