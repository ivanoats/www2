#!/usr/bin/env ruby

require 'net/pop'
require File.dirname(__FILE__) + '/../config/environment'

logger = RAILS_DEFAULT_LOGGER

logger.info "Running Mail Importer..." 
Net::POP3.start("server.sustainablewebsites.com", nil, "paypal-received", "BIB3UkW:umGH") do |pop|
  if pop.mails.empty?
    logger.info "NO MAIL" 
  else
    pop.mails.each do |email|
      begin
        logger.info "receiving mail..." 
        PayPalPayments.receive(email.pop)
        email.delete
      rescue Exception => e
        logger.error "Error receiving email at " + Time.now.to_s + "::: " + e.message
      end
    end
  end
end
logger.info "Finished Mail Importer."