#!/usr/bin/env ruby

require 'net/pop'
require File.dirname(__FILE__) + '/../config/environment'

logger = RAILS_DEFAULT_LOGGER

# finds text after the needle in a haystack, until the end character
def find_after_until(haystack, needle, end_char )
  start_position = haystack.index(needle) + needle.length
  end_position = haystack.index(end_char, start_position) - 1
  haystack[start_position..end_position]
end

#logger.info "Running Mail Importer Test..." 
email = ""
Net::POP3.start("server.sustainablewebsites.com", nil, "paypal-received@sustainablewebsites.com", "BIB3UkW:umGH") do |pop|
  email = pop.mails.first.pop
end
email_parsed = TMail::Mail.parse(email)
email_body = email_parsed.parts[0].body
puts email_body
puts "/----------------------------------/"
amount =  find_after_until(email_body,"Amount: $"," ").to_i
subscription_number = find_after_until(email_body,"Subscription Number: ","\n")
#puts find_after_until(email_body,"Subscription Name: ", "\n")
domain_name = find_after_until(find_after_until(email_body,"Subscription Name: ", "\n"), "[","]")
user_email = find_after_until(email_body,"Email: ","\n")

puts "Received from PayPal on date: " + email_parsed.date.strftime('%Y-%m-%d')
puts "unix date: " + email_parsed.date.to_i.to_s
puts "Amount is: " + amount.to_s
puts "Subscription number is: " + subscription_number
puts "Domain name is: " + domain_name
puts "Email is: " + user_email

# find by txn_id (subscription number)
order = Whmaphostingorder.find_by_txn_id(subscription_number)
if order.nil?
  order = Whmaphostingorder.find_by_domain_name(domain_name)
end
if order.nil?
  order = Whmaphostingorder.find_by_email(user_email)
end
if order.nil?
  puts "failed to find any info in email"
end

pp order


#logger.info "Finished Mail Importer Test."