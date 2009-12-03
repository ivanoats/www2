require 'lib/billing_system'

namespace :billing do
  include BillingSystem
  
  desc 'Hostings'
  task :run => :environment do
    hostings
  end
  
  desc 'Accounts'
  task :run => :environment do
    accounts
  end
  
  desc 'Domains'
  task :run => :environment do
    domains
  end
  
  desc 'Add Ons'
  task :run => :environment do
    add_ons
  end
  
  
end