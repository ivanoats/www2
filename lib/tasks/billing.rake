require 'lib/billing_system'

namespace :billing do
  include BillingSystem
  
  desc "All Billing Tasks"
  task :all => :environment do
    #these need to be done first so accounts are charged the same day a balance is due
    Rake::Task["billing:hostings"].invoke
    Rake::Task["billing:domains"].invoke
    Rake::Task["billing:add_ons"].invoke

    Rake::Task["billing:accounts"].invoke    
  end
  
  desc 'Hostings'
  task :hostings => :environment do
    hostings
  end
  
  desc 'Accounts'
  task :accounts => :environment do
    accounts
  end
  
  desc 'Domains'
  task :domains => :environment do
    domains
  end
  
  desc 'Add Ons'
  task :add_ons => :environment do
    add_ons
  end


end