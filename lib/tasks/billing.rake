require 'lib/billing_system'

namespace :billing do
  include BillingSystem
  
  desc 'Run the daily billing script'
  task :run => :environment do
    puts "Starting Billing worker at #{Time.now}"
    hostings
    puts "Completed hostings at #{Time.now}"    
    accounts
    puts "Billing worker completed at #{Time.now}.  "
  end
end