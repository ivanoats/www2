require 'lib/billing_system'

namespace :billing do
  
  desc "All Billing Tasks"
  task :all => :environment do
    BililngSystem.charge_all
  end
  
  desc 'Hostings'
  task :hostings => :environment do
    BillingSystem.charge_hostings
  end
  
  desc 'Accounts'
  task :accounts => :environment do
    BillingSystem.charge_accounts
  end
  
  desc 'Domains'
  task :domains => :environment do
    BillingSystem.charge_domains
  end
  
  desc 'Add Ons'
  task :add_ons => :environment do
    BillingSystem.charge_addons
  end


end