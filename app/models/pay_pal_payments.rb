# receives paypal emails and marks invoices paid in the whmap billing database
class PayPalPayments < ActionMailer::Base
  def self.receive(email)
    if email.subject.downcase == "you have received a subscription payment" then
      # read payment info from email. amount, txn_id (paypal subscription number)
      amount =  find_after_until(email_body,"Amount: $"," ").to_i
      subscription_number = find_after_until(email_body,"Subscription Number: ","\n")
      domain_name = find_after_until(find_after_until(email_body,"Subscription Name: ", "\n"), "[","]")
      
      # associate it to a order id (oid) or user id (uid)
      order = Whmaphostingorder.find_by_txn_id(subscription_number)
      if order.nil?
        order = Whmaphostingorder.find_by_domain_name(domain_name)
      end
      if order.nil?
        order = Whmaphostingorder.find_by_email(user_email)
      end
      if order.nil?
        raise error_text "failed to find any valid info in paypal email: " email.
      end
       
      # find an invoice for that user (or order) around the date of the email
      # find all unpaid invoices for that user in the order
      unpaid_invoices = Whmapinvoice.find(:all, :conditions => { :uid => order.uid, :status => 0 } )
      
      # if there's only one unpaid invoice, mark that invoice as paid
      if unpaid_invoices.size == 1
        unpaid_invoices.first.status = 1
        unpaid_invoices.first.save!
      else
      # if there's more than one unpaid invoice, mark the invoice that's in the same month as paid
        unpaid_invoices.each do |invoice|
          # figger out month of invoice
          # if it matches the email date, mark it as paid, and exit loop
          if Time.at(invoice.due_date).month == email.date.month
            invoice.status = 1
            invoice.save!
            break
          end
        end
        # if i looped through all and last is still unpaid, make an error
        if unpaid.invoices.last.status == 0
          error_text = "couldn't match paypal email with outstanding invoice for uid: " + order.uid + ", domain name: " + order.domain_name
          logger.warn(error_text)
          raise error_text
        end
      end #unpaid invoices
      
    end # end if email is a subscription payment email  
  end # self.receive
  
  # finds the value (text) after the needle(key) in a haystack, until the end character
  def find_after_until(haystack, needle, end_char )
    start_position = haystack.index(needle) + needle.length
    end_position = haystack.index(end_char, start_position) - 1
    haystack[start_position..end_position]
  end # find_after_until
end
