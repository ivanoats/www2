require 'lib/billing_system'

namespace :billing do
  include BillingSystem
  
  desc "All Billing Tasks"
  task :all => :environment do
    tasks = tasks_in_namespace("billing")
    tasks.each do |task|
      Rake::Task["#{task.name}"].invoke
    end
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

private
  def tasks_in_namespace(ns)
    #grab all tasks in the supplied namespace
    tasks = Rake.application.tasks.select { |t| t.name =~ /^#{ns}:/ }

    #make sure we don't include the :all task
    tasks.reject! { |t| t.name =~ /:all/ }
  end
end