
def create_hosting_from_order(order)
  Hosting.new(:server => Server.find_by_ip_address(order.whmapserver.server_ip),
    :username => order.whm_username,
    :password => order.whm_password,
    :domain => order.domain_name,
    :next_charge_on => Time.at(order.next_due_date.to_i),
    :custom_cost => order.total_due_reoccur,
    :custom_recurring_month => (order.payment_term == 'Annual' ? 12 : 1)
 )
end

namespace :whm do
  
  desc 'Migrate Users'
  task :migrate => :environment do
    
    
    
    
    #addons to determine price??
    #custom_recurring_month??
    
    Whmapserver.find(:all).each { |server|
      Server.create!(:name => server.server_name,  :ip_address => server.server_ip, :primary_ns => server.primary_ns, :primary_ns_ip => server.primary_ns_ip, :secondary_ns => server.secondary_ns, :secondary_ns_ip => server.secondary_ns_ip, :max_accounts => server.max_accounts)
      # missing whm_user whm_pass whm_key
    }
    
    #TODO setup_cost
    Whmapaddon.find(:all).each { |addon|
      #TODO ... some of these have $0 recurring cost ...
      Product.create!(:name => addon.addon_name, :description => addon.addon_description, :recurring_month => 0, :kind => "addon", :cost => addon.addon_cost, :status => "active")
    }
    
    #TODO find users that are active vs inactive
    
    Whmapuser.find(:all, :limit => 5).each { |user|
      #create an account 
      @account = Account.new(:first_name => user.first_name,
                             :last_name => user.last_name,
                             :organization => user.organization_name,
                             :phone => user.phone,
                             :email => user.email
                             )
      @account.organization = "Organization" if @account.organization.blank?
      
      @account.address = Address.new(:street => user.street_address_1 + user.street_address_2,
                                     :city => user.city, 
                                     :state => user.state,
                                     :zip => user.zip_code,
                                     :country => user.country)
      
      @account.save!
      
      
      initial_password = 'password' #TODO generate a unique password
      @user = User.find_by_email(user.email) || User.new(:login => user.username.gsub(/ /,'_'), :email => user.email, :password => initial_password, :password_confirmation => initial_password)
      @account.users << @user
      @user.update_attribute('state','active')
      
      #TODO mail to user with login and password
      
      user.whmaphostingorder.active.each { |order|
       @hosting = create_hosting_from_order(order)
       @account.hostings << @hosting
       order.addon_choices.split('|').each {|id|
         add_on = Whmapaddon.find(id)
         @account.add_ons << AddOn.new(:product => Product.find(:first, :conditions => {:name => add_on.addon_name, :description => addon.addon_description, :cost => add_on.addon_cost}))
       }
       @hosting.update_attribute('state', 'active')
      }
      
      user.whmaphostingorder.suspended.each { |order|
       @hosting = create_hosting_from_order(order)
       @account.hostings << @hosting
       @hosting.update_attribute('state', 'suspended')
      }
    }
    
  end
end