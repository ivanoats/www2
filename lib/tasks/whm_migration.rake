
def create_hosting_from_order(order)
  Hosting.new(:server => Server.find_by_ip_address(order.whmapserver.server_ip),
    :username => order.whm_username,
    :password => order.whm_password,
    :domain => order.domain_name,
    :next_charge_on => Time.at(order.next_due_date.to_i),
    :product => begin
      Product.all.find { |product| product.data[:package] == order.whmappackage.whm_package_name }
    rescue => e
      throw "Product not found for #{order.whmappackage.whm_package_name}"
    end
    #:custom_cost => order.total_due_reoccur,
    #:custom_recurring_month => (order.payment_term == 'Annual' ? 12 : 1)
 )
end

def account_for_user(user)
  
end

namespace :whm do
  
  desc 'Migrate supporting objects'
  task :scaffold => :environment do
    Product.destroy_all
    
    Whmappackage.all.each { |whmap_product|
      unless Product.all.find { |product| product.data[:package] == whmap_product.whm_package_name }
        Product.create!({
          :name            => whmap_product.package_name,
          :description     => "",
          :cost            => whmap_product.monthly_cost,
          :recurring_month => 1,
          :status          => "active",
          :kind            => "package",
          :data            => {:package => whmap_product.whm_package_name}
        }) if whmap_product.monthly_cost > 0
        
        Product.create!({
          :name            => whmap_product.package_name,
          :description     => "",
          :cost            => whmap_product.annual_cost,
          :recurring_month => 12,
          :status          => "active",
          :kind            => "package",
          :data            => {:package => whmap_product.whm_package_name}
        }) if whmap_product.annual_cost > 0
        
        Product.create!({
          :name            => whmap_product.package_name,
          :description     => "",
          :cost            => 0,
          :recurring_month => 0,
          :status          => "active",
          :kind            => "package",
          :data            => {:package => whmap_product.whm_package_name}
        }) if whmap_product.monthly_cost == 0 &&  whmap_product.annual_cost == 0
      end
    }

    Whmapaddon.find(:all).each { |addon|
      if(addon.coupon == 1)
        Product.create!(:name => addon.addon_name, :description => addon.addon_description, :kind => "coupon", :status => "active", :data => {:code => addon.coupon_code, :percentage => addon.coupon_discount_percent, :discount => addon.coupon_discount_whole, :expires => Time.at(addon.expires.to_i)})
      elsif(addon.setup_cost == 0)
        Product.create!(:name => addon.addon_name, :description => addon.addon_description, :recurring_month => 1, :kind => "addon", :cost => addon.addon_cost, :status => "active")
      elsif(addon.addon_cost == 0)
        Product.create!(:name => addon.addon_name, :description => addon.addon_description, :recurring_month => 0, :kind => "addon", :cost => addon.setup_cost, :status => "active")
      else
        pp addon
        throw "Unsupported addon!!!"
      end
    }
    
    Server.destroy_all
    
    Whmapserver.find(:all, :conditions => {:server_name => ['sustainablewebsites','swcom3','swcom7','swcom11','swcom13','uk1sw']}).each { |server|
      Server.create!(:name => server.server_name,  :ip_address => server.server_ip, :primary_ns => server.primary_ns, :primary_ns_ip => server.primary_ns_ip, :secondary_ns => server.secondary_ns, :secondary_ns_ip => server.secondary_ns_ip, :max_accounts => server.max_accounts, :whm_user => 'wpdnet', :whm_pass => 'coo2man')
    }

    Server.create! :name => "Test Server", :ip_address => '174.132.225.221', :whm_user => 'wpdnet', :whm_pass => 'coo2man'


    # "sustainw"," sustainablewebsites"," 74.55.133.197","yes","server.sustainablewebsites.com","main server new accounts go here"
    #     "greenweb"," greenwebserver.com",0,"no",,"old server - accounts were migrated to sustainw"
    #     "ecobr"," ecobreeze",0," no",," ""old server - accounts were migrated to sustainw"""
    #     "wphnet"," windpowerhostnet",0,"no",," ""old server - accounts were migrated to sustainw"""
    #     "swcom3"," swcom3"," 70.47.89.20","yes","r9.nswebhost.com","reseller access, not root"
    #     "swcom7"," swcom7","69.73.144.27","yes","r12.nswebhost.com","reseller access, not root"
    #     "swcom11"," swcom11","207.210.64.55","yes","r8.nswebhost.com","reseller access, not root"
    #     "swcom13"," swcom13","207.210.64.50","yes","r15.nswebhost.com","reseller access, not root"
    #     "uk1sw"," uk1sw","77.74.195.152","yes","london.nswebhost.com","reseller access, not root"
    #     
    
    
  end
  
  
  
  desc 'Migrate Users'
  task :migrate => :environment do
    
    
    # WhmaphostingOrder.active.each { |order|
    #       @hosting = create_hosting_from_order(order)
    #       @account = account_for_user(order.whmapuser)
    #       @account.hostings << @hosting
    #       
    #       order.addon_choices.split('|').each {|id|
    #         add_on = Whmapaddon.find(id)
    #         #TODO verify this
    #         @account.add_ons << AddOn.new(:product => Product.find(:first, :conditions => {:name => add_on.addon_name, :description => addon.addon_description, :cost => add_on.addon_cost}))
    #       }
    #       @hosting.update_attribute('state', 'active')
    #     }
    
    User.find_by_email('padraicmcgee@gmail.com').destroy
    
    Whmapuser.find(:all, :include => :whmaphostingorder, :conditions => ['hosting_order.status = ?',1]).each { |user| 
      
        #TESTING
        user.email = 'padraicmcgee@gmail.com'
      
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
         if ["greenwebserver.com","ecobreeze", "windpowerhostnet"].include? order.whmapserver.server_name
          
         elsif Server.find_by_ip_address(order.whmapserver.server_ip) #only create if we have an active server
           @hosting = create_hosting_from_order(order)
           @account.hostings << @hosting
           order.addon_choices.split('|').each {|id|
             add_on = Whmapaddon.find(id)
             @account.add_ons << AddOn.new(:product => Product.find(:first, :conditions => {:name => add_on.addon_name, :description => addon.addon_description, :cost => add_on.addon_cost}))
           }
           @hosting.update_attribute('state', 'active')
         else
           throw "Server not found for ip address #{order.whmapserver.server_ip} #{order.whmapserver.server_name}"
         end
         
         #     "greenweb"," greenwebserver.com",0,"no",,"old server - accounts were migrated to sustainw"
         #     "ecobr"," ecobreeze",0," no",," ""old server - accounts were migrated to sustainw"""
         #     "wphnet"," windpowerhostnet",0,"no",," ""old server - accounts were migrated to sustainw"""
         
        }
        
        # user.whmaphostingorder.suspended.each { |order|
        #          @hosting = create_hosting_from_order(order)
        #          @account.hostings << @hosting
        #          @hosting.update_attribute('state', 'suspended')
        #         }
      }
    
  end
end