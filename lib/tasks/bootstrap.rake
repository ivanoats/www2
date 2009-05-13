namespace :bootstrap do
  desc "Bootstrap a set of admin users"
  task :admins => :environment do
    puts "Bootstrapping admins"
    
    Role.create! :name => "Administrator"
    Role.create! :name => "User"
    Role.create! :name => "Editor"
    
    admin = User.create! :login => "admin", :password => "password", :password_confirmation => "password", :email => "admin@sample.com"
    admin.roles << Role.administrator
    admin.register!
    admin.activate!
    
  end

  task :test_account => :environment do
    puts "Creating test account"
    account = Account.create! :first_name => "Admin", :last_name => "istrator", :organization => "Test Organization", :users => [User.first], :balance => -100
    account.payments << Payment.new(:amount => 50)
    account.charges << Charge.new(:amount => 150)
  end
  
  task :server => :environment do
    puts "Creating Whm Server"
    server = Server.create! :name => "Test Server", :ip_address => '174.132.225.221', :whm_user => 'wpdnet', :whm_pass => 'coo2man'
  end

  desc "Bootstrap initial products"
  task :products => :environment do
    puts "bootstrapping products"
    
    # Monthly packages
    Product.create!( {
      :name            => "Basic Web Hosting Subscription",
      :description     => "Basic Web Hosting Description",
      :cost            => 10.00,
      :recurring_month => 1,
      :status          => "active",
      :kind            => "package",
      :data            => {:package => 'wpdnet_basic'}
    })
    
    Product.create!( {
      :name            => "Small Business Web Hosting Subscription",
      :description     => "Small Business Web Hosting Description",
      :cost            => 20.00,
      :recurring_month => 1,
      :status          => "active",
      :kind            => "package",
      :data            => {:package => 'wpdnet_sb'}
      
    })

    Product.create!( {
      :name            => "Professional Web Hosting Subscription",
      :description     => "Professional Web Hosting Description",
      :cost            => 30.00,
      :recurring_month => 1,
      :status          => "active",
      :kind            => "package",
      :data            => {:package => 'wpdnet_pro'}
      
    })

    # Yearly packages
    Product.create!( {
      :name            => "Basic Web Hosting Subscription",
      :description     => "Basic Web Hosting Yearly",
      :cost            => 100.00,
      :recurring_month => 12,
      :status          => "active",
      :kind            => "package",
      :data            => {:package => 'wpdnet_basic'}
    })
    
    Product.create!( {
      :name            => "Small Business Web Hosting Subscription",
      :description     => "Small Business Web Hosting Yearly",
      :cost            => 199.00,
      :recurring_month => 12,
      :status          => "active",
      :kind            => "package",
      :data            => {:package => 'wpdnet_sb'}
      
    })

    Product.create!( {
      :name            => "Professional Web Hosting Subscription",
      :description     => "Professional Web Hosting Yearly",
      :cost            => 299.00,
      :recurring_month => 12,
      :status          => "active",
      :kind            => "package",
      :data            => {:package => 'wpdnet_pro'}
    })


    
    Product.create!( {
      :name            => "Dedicated IP Address",
      :description     => "All accounts already come with a static shared IP. If you will be installing a secure certificate or have another need for a unique dedicated IP, you want this option. <strong>You do not need a dedicated IP address unless you have a SSL certificate already purchased and ready to install.</strong>",
      :cost            => 4.00,
      :recurring_month => 1,
      :status          => "active",
      :kind            => "addon"
    })
    
    Product.create!({
      :name            => "WordPress Pie",
      :description     => "Professional installation of WordPress, including 10 of the most useful plugins and 10 site themes. Selecting this option will enable you to start editing your site right away with one of the most popular and effective systems available.  Use <a href=\"http://www.sustainablewebsites.com/wordpress-pie\">WordPress Pie</a> to learn to create a simple and effective website. Helps you grow your business, without needing to learn complex programming. Includes 30 minutes of telephone coaching and a 5 page tutorial document.",
      :cost            => 100.00,
      :recurring_month => 0,
      :status          => "active",
      :kind            => "addon"
    })
  end

  desc "Run all bootstrap tasks"
  task :all => ['db:schema:load'] do
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
