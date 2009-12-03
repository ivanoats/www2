require 'rake'

namespace :cron do
  
  task "Hourly cron tasks"
  task :hourly => :environment do
    tasks = []
    tasks.each do |task|
      
      begin
        Rake::Task[task].invoke
      rescue => e
        HoptoadNotifier.notify(
          :error_class => "Rake #{task} Error",
          :error_message => "Rake #{task} Error: #{e.message}"
        )
      end
    end
  end
  
  
  desc "Daily cron tasks"
  task :daily => :environment do
    
    tasks = ["db:backup"]
    tasks.each do |task|
      
      begin
        Rake::Task[task].invoke
      rescue => e
        HoptoadNotifier.notify(
          :error_class => "Rake #{task} Error",
          :error_message => "Rake #{task} Error: #{e.message}"
        )
      end
    end
  end
  
  desc "Weekly cron tasks"
  task :weekly => :environment do
    
    tasks = []
    tasks.each do |task|

      begin
        Rake::Task[task].invoke
      rescue => e
        HoptoadNotifier.notify(
          :error_class => "Rake #{task} Error",
          :error_message => "Rake #{task} Error: #{e.message}"
        )
      end
    end
  end
    
end
