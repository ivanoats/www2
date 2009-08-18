# receives paypal emails and marks invoices paid in the whmap billing database
class PayPalPayments < ActionMailer::Base
  def self.receive(email)
    if email.subject.downcase == "you have received a subscription payment" then
      # read payment info from email. amount, txn_id (paypal subscription number)
      amount =  find_after_until(email_body,"Amount: $"," ").to_i
      subscription_number = find_after_until(email_body,"Subscription Number: ","\n")
      domain_name = find_after_until(find_after_until(email_body,"Subscription Name: ", "\n"), "[","]")
      
      # associate it to a order id (oid) or user id (uid)
      # find an invoice for that user (or order) around the date of the email
      # mark that invoice as paid
      
    end # end if email is a subscription payment email
  end # self.receive
  
  # finds the value (text) after the needle(key) in a haystack, until the end character
  def find_after_until(haystack, needle, end_char )
    start_position = haystack.index(needle) + needle.length
    end_position = haystack.index(end_char, start_position) - 1
    haystack[start_position..end_position]
  end # find_after_until
end
