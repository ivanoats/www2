
namespace :whm do
  
  desc 'Migrate Users'
  task :migrate => :environment do
    
    #experimental - create a server for each unique hosting IP
    Whmaphostingorder.active.find(:all, :select => 'distinct(ip)').each { |hosting|
      Server.create(:ip_address => hosting.ip)
    }
    
    
    Whmapuser.find(:all, :limit => 1).each { |user|
      #create an account 
      @account = Account.new(:first_name => user.first_name,
                             :last_name => user.last_name,
                             :organization => user.organization_name || "Organization",
                             :phone => user.phone,
                             :email => user.email
                             )
      
      @account.address = Address.new(:street => user.street_address_1 + user.street_address_2,
                                     :city => user.city, 
                                     :state => user.state,
                                     :zip => user.zip_code,
                                     :country => user.country)
      
      @account.save
      
      initial_password = 'password' #TODO generate a unique password
      @user = User.new(:login => user.username, :email => user.email, :password => initial_password, :password_confirmation => initial_password)
      @account.users << @user
      @user.update_attribute('state','active')
      
      #TODO mail unique password
      
      user.whmaphostingorder.active.each { |order|
        @hosting = Hosting.new(:server => Server.find_by_ip_address(order.ip),
          :username => order.whm_username,
          :password => order.whm_password,
          :domain => order.domain_name,
          :next_charge_on => Time.at(order.next_due_date),
          :custom_cost => order.total_due_reoccur,
          :custom_recurring_month = (order.payment_term == 'Annual' ? 12 : 1)
       )
       @account << @hosting
       @hosting.update_attribute('state', 'active')
      }
    }
    
  end
end