namespace :bootstrap do
  desc "Bootstrap a set of admin users"
  task :admins => :environment do
    puts "Bootstrapping admins"
    
    Role.create! :name => "Administrator"
    Role.create! :name => "User"
    Role.create! :name => "Editor"
    
    admin = User.create! :login => "admin", :password => "password", :password_confirmation => "password", :email => "admin@sample.com"
    admin.register!
    admin.activate!
    
  end

  task :test_account => :environment do
    puts "Creating test account"
    account = Account.create! :first_name => "Admin", :last_name => "istrator", :organization => "Test Organization", :users => [User.first]
  end


  desc "Run all bootstrap tasks"
  task :all do
    tasks = tasks_in_namespace("bootstrap")
    tasks.each do |task|
      Rake::Task["#{task.name}"].invoke
    end
  end  

private
  def tasks_in_namespace(ns)
    #grab all tasks in the supplied namespace
    tasks = Rake.application.tasks.select { |t| t.name =~ /^#{ns}:/ }
  
    #make sure we don't include the :all task
    tasks.reject! { |t| t.name =~ /:all/ }
  end
end
