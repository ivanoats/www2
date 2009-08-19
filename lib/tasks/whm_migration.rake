namespace :whm do
  
  desc 'Migrate Users'
  task :migrate => :environment do
    
    Whmapserver.find(:all).each { |server|
      Server.create!(:name => server.server_name,  :ip_address => server.server_ip, :primary_ns => server.primary_ns, :primary_ns_ip => server.primary_ns_ip, :secondary_ns => server.secondary_ns, :secondary_ns_ip => server.secondary_ns_ip, :max_accounts => server.max_accounts)
      # missing whm_user whm_pass whm_key
    }
    
    #TODO find users that are active vs inactive
    
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
      @user = User.find_by_email(user.email) || User.new(:login => user.username, :email => user.email, :password => initial_password, :password_confirmation => initial_password)
      @account.users << @user
      @user.update_attribute('state','active')
      
      #TODO mail unique password
      
      user.whmaphostingorder.active.each { |order|
        @hosting = Hosting.new(:server => Server.find_by_ip_address(order.server.server_ip),
          :username => order.whm_username,
          :password => order.whm_password,
          :domain => order.domain_name,
          :next_charge_on => Time.at(order.next_due_date),
          :custom_cost => order.total_due_reoccur,
          :custom_recurring_month => (order.payment_term == 'Annual' ? 12 : 1)
       )
       @account << @hosting
       @hosting.update_attribute('state', 'active')
      }
      
      user.whmaphostingorder.suspended.each { |order|
        @hosting = Hosting.new(:server => Server.find_by_ip_address(order.server.server_ip),
          :username => order.whm_username,
          :password => order.whm_password,
          :domain => order.domain_name,
          :next_charge_on => Time.at(order.next_due_date),
          :custom_cost => order.total_due_reoccur,
          :custom_recurring_month => (order.payment_term == 'Annual' ? 12 : 1)
       )
       @account << @hosting
       @hosting.update_attribute('state', 'suspended')
      }
    }
    
  end
end