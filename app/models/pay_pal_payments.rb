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

    logger.info('parsing email')
    email_parsed = TMail::Mail.parse(email)
    email_body = email_parsed.parts[0].body
    email_message_id = email_parsed.message_id
    logger.info('email message id: '+email_message_id)

    # if email_parsed.messageid is not in PayPalEmailLogs table and it's a payment notification email
    logger.info('checking to see if email id has been processed before')
    if PayPalEmailLog.find_by_messageid(email_message_id) == nil \
       && email_parsed.subject.downcase == "you have received a subscription payment" then

      logger.info('No, this email has not been processed before')
      # read payment info from email. amount, txn_id (paypal subscription number)
      logger.info('Parsing amount, subscription number, domain name and email from email body')
      amount =  find_after_until(email_body,"Amount: $"," ").to_i
      subscription_number = find_after_until(email_body,"Subscription Number: ","\n")
      # convert Subscription name to domain name process
      subscription_name = find_after_until(email_body, "Subscription Name: ", "\n")
      # does it have [ ] - then only use that part
      if subscription_name.slice(/\[(.+)\]/,1) != nil # then it has [ ]
        domain_name = subscription_name.slice(/\[(.+)\]/,1)
      elsif subscription_name.slice(/\s/) != nil #does it have spaces? then we can't figure out the domain name 
        domain_name = nil
      else # then it's already fine
        domain_name = subscription_name
      end 

      # domain_name = find_after_until(find_after_until(email_body,"Subscription Name: ", "\n"), "[","]")
      user_email = find_after_until(email_body,"Email: ","\n")
      logger.info('amount: '+amount.to_s)
      logger.info('domain_name: '+domain_name) unless domain_name.nil?
      # strip http:// and www. out of domain name
      domain_name.gsub!('http://','') unless domain_name.nil?
      domain_name.gsub!('www.','') unless domain_name.nil?
      logger.info('stripped domain_name: '+domain_name) unless domain_name.nil?
      logger.info('user_email: '+user_email)

      # associate it to a order id (oid) or user id (uid)
      logger.info('looking for an order by txn_id')
      order = Whmaphostingorder.find_by_txn_id(subscription_number)
      logger.info('found order id:' + order.id.to_s ) if !order.nil?
      if domain_name != "domain_name.com" && order.nil?
        logger.info('domain_name was not domain_name.com and order was not nil')
        order = Whmaphostingorder.find_by_domain_name(domain_name)
        logger.info('order id:' + order.id.to_s) if !order.nil?
      end
      if order.nil?
        logger.info('order was nil, looking for Whmapuser by email')
        user = Whmapuser.find_by_email(user_email)
        order = Whmaphostingorder.find_by_uid(user)
        logger.info('order id:' + order.id.to_s) if !order.nil?
      end
      if order.nil?
        error_text = "[Billing Warning] : Order was still nil after trying to find by email, domain name and subscription number\n" \
                   + email_body
        new_log = PayPalEmailLog.create(:messageid => email_message_id,
                                        :comments => error_text)
        new_log.save
        logger.warn(error_text)
        return 
        # raise( "Billing Warning: failed to find any valid info in paypal email: " + email_body )
      end
      
      # maybe it was paid already? check month
      email_month = email_parsed.date.month
      invoice_for_month = Whmapinvoice.find(:first, 
                                            :conditions => [ "uid = ? AND month(from_unixtime(due_date)) = ?", order.uid, email_month])

      # did I find a matching invoice? if not, what
      if invoice_for_month.nil?
        error_text = "[Billing warning] : Could not find invoice for the month that the email was from\n" \
                   + "email_month: " + email_parsed.date.month.to_s + "\n" \
                   + email_body
        new_log = PayPalEmailLog.create(:messageid => email_message_id,
                                        :comments => error_text)
        new_log.save!
        return
      end

      if invoice_for_month.paid?
        logger.info('invoice was already marked as paid, ignoring email')
        new_log = PayPalEmailLog.create(:iid => invoice_for_month.id, 
                                        :messageid => email_message_id,
                                        :comments => 'invoice was already marked as paid, ignoring email')
        new_log.save!
        return
      else #unpaid
        invoice_for_month.mark_as_paid
        new_log = PayPalEmailLog.create(:iid => invoice_for_month.id, 
                                        :messageid => email_message_id,
                                        :comments => 'marked invoice paid')
        new_log.save!
        return
      end
      
    else
      logger.info('email has already been processed')
    end # end if email is a subscription payment email  
  end # self.receive
  
end
