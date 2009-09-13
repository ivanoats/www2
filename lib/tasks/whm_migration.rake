require 'pp'

namespace :whm do
  
  desc 'Migrate supporting objects'
  task :scaffold => :environment do
    Product.destroy_all
    
    Whmappackage.all.each { |whmap_product|
      #unless Product.all.find { |product| product.data[:package] == whmap_product.whm_package_name }
        Product.create!({
          :name            => whmap_product.package_name,
          :description     => "",
          :cost            => whmap_product.monthly_cost,
          :recurring_month => 1,
          :kind            => "package",
          :data            => {:package => whmap_product.whm_package_name},
          :whmappackage => whmap_product
        }) if whmap_product.monthly_cost > 0
        
        Product.create!({
          :name            => whmap_product.package_name,
          :description     => "",
          :cost            => whmap_product.annual_cost,
          :recurring_month => 12,
          :kind            => "package",
          :data            => {:package => whmap_product.whm_package_name},
          :whmappackage => whmap_product
        }) if whmap_product.annual_cost > 0
        
        Product.create!({
          :name            => whmap_product.package_name,
          :description     => "",
          :cost            => 0,
          :recurring_month => 0,
          :kind            => "package",
          :data            => {:package => whmap_product.whm_package_name},
          :whmappackage => whmap_product
        }) if whmap_product.monthly_cost == 0 &&  whmap_product.annual_cost == 0
      #end
    }

    Product.packages.each { |product| product.disable! }

    # Monthly packages
    Product.create!( {
      :name            => "Basic Web Hosting Subscription",
      :description     => "Basic Web Hosting Description",
      :cost            => 10.00,
      :recurring_month => 1,
      :kind            => "package",
      :data            => {:package => 'wpdnet_basic'}
    })
    
    Product.create!( {
      :name            => "Small Business Web Hosting Subscription",
      :description     => "Small Business Web Hosting Description",
      :cost            => 20.00,
      :recurring_month => 1,
      :kind            => "package",
      :data            => {:package => 'wpdnet_sb'}
      
    })

    Product.create!( {
      :name            => "Professional Web Hosting Subscription",
      :description     => "Professional Web Hosting Description",
      :cost            => 30.00,
      :recurring_month => 1,
      :kind            => "package",
      :data            => {:package => 'wpdnet_pro'}
      
    })

    # Yearly packages
    Product.create!( {
      :name            => "Basic Web Hosting Subscription",
      :description     => "Basic Web Hosting Yearly",
      :cost            => 100.00,
      :recurring_month => 12,
      :kind            => "package",
      :data            => {:package => 'wpdnet_basic'}
    })
    
    Product.create!( {
      :name            => "Small Business Web Hosting Subscription",
      :description     => "Small Business Web Hosting Yearly",
      :cost            => 199.00,
      :recurring_month => 12,
      :kind            => "package",
      :data            => {:package => 'wpdnet_sb'}
      
    })

    Product.create!( {
      :name            => "Professional Web Hosting Subscription",
      :description     => "Professional Web Hosting Yearly",
      :cost            => 299.00,
      :recurring_month => 12,
      :kind            => "package",
      :data            => {:package => 'wpdnet_pro'}
    })


    
    Product.create!( {
      :name            => "Dedicated IP Address",
      :description     => "All accounts already come with a static shared IP. If you will be installing a secure certificate or have another need for a unique dedicated IP, you want this option. <strong>You do not need a dedicated IP address unless you have a SSL certificate already purchased and ready to install.</strong>",
      :cost            => 4.00,
      :recurring_month => 1,
      :kind            => "addon"
    })
    
    Product.create!({
      :name            => "WordPress Pie",
      :description     => "Professional installation of WordPress, including 10 of the most useful plugins and 10 site themes. Selecting this option will enable you to start editing your site right away with one of the most popular and effective systems available.  Use <a href=\"http://www.sustainablewebsites.com/wordpress-pie\">WordPress Pie</a> to learn to create a simple and effective website. Helps you grow your business, without needing to learn complex programming. Includes 30 minutes of telephone coaching and a 5 page tutorial document.",
      :cost            => 100.00,
      :recurring_month => 0,
      :kind            => "addon"
    })

    Whmapaddon.find(:all).each { |addon|
      if(addon.coupon == 1)
        Product.create!(:name => addon.addon_name, :description => addon.addon_description, :kind => "coupon", :data => {:code => addon.coupon_code, :percentage => addon.coupon_discount_percent, :discount => addon.coupon_discount_whole, :expires => Time.at(addon.expires.to_i)})
      elsif(addon.setup_cost == 0)
        Product.create!(:name => addon.addon_name, :description => addon.addon_description, :recurring_month => 1, :kind => "addon", :cost => addon.addon_cost)
      elsif(addon.addon_cost == 0)
        Product.create!(:name => addon.addon_name, :description => addon.addon_description, :recurring_month => 0, :kind => "addon", :cost => addon.setup_cost)
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
  
  task :clear => :environment do
    Account.delete_all
    Hosting.delete_all
    Domain.delete_all
    Order.delete_all
    Product.delete_all
    
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
    
    begin
      User.find_by_email('padraicmcgee@gmail.com').destroy
    rescue
    end  
    
    Whmapuser.find(:all, :include => :whmaphostingorder, :conditions => ['hosting_order.status = ?',1]).each { |user| 
      
        #TESTING
        user.email = 'padraicmcgee@gmail.com'
      
        #create an account 
        @account = Account.new(:first_name => user.first_name,
                               :last_name => user.last_name,
                               :organization => user.organization_name,
                               :phone => user.phone,
                               :email => user.email,
                               :whmapuser => user
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
           puts "Ignoring order on #{order.whmapserver.server_name}"
         elsif order.whmappackage.nil?
           puts "!!! Ignoring order for missing package "
           pp order
         elsif Server.find_by_ip_address(order.whmapserver.server_ip) #only create if we have an active server
           @hosting = Hosting.new(:server => Server.find_by_ip_address(order.whmapserver.server_ip),
             :username => order.whm_username,
             :password => order.whm_password,
             :domain => order.domain_name,
             :next_charge_on => Time.at(order.next_due_date.to_i),
             :whmaphostingorder => order,
             :product => order.whmappackage.product
          )
          
          throw "Product not found for #{order.whmappackage.whm_package_name}" if @hosting.product.nil?
          
           @account.hostings << @hosting
           order.addon_choices.split('|').each {|id|
             add_on = Whmapaddon.find(id)
             @account.add_ons << AddOn.new(:product => Product.find(:first, :conditions => {:name => add_on.addon_name, :description => add_on.addon_description, :cost => add_on.addon_cost}))
           }
           
           order.whmapinvoice.each { |invoice|
             case invoice.status
             when 0 #unpaid
               Charge.create!(:account => @account, :chargable => @hosting, :amount => invoice.total_due_reoccur, :created_at => Time.at(invoice.created.to_i))
               @account.balance -= invoice.total_due_reoccur
             when 1 #paid
               Charge.create!(:account => @account, :chargable => @hosting, :amount => invoice.total_due_reoccur, :created_at => Time.at(invoice.created.to_i))
               Payment.create!(:account => @account, :amount => invoice.total_due_reoccur, :created_at => Time.at(invoice.date_paid.to_i))
             else
               pp order
               pp invoice
               puts "Unknown invoice status"
             end
             
             #8610, uid: 631, oid: 620, due_date: 1230530400, payment_method: 8, txn_id: "", additional_information: "", invoice_details: "", invoice_terms: 0, status: 0, created: 1230530400, date_paid: 0, invoice_number: 18534, invoice_type: 0, total_due_today: 0.0, total_due_reoccur: 10.0, charge_tax: 0.0, tax_type: "", extras: "", master: 1, checkout_id: "">
             
             
           }
           @account.save
           @hosting.update_attribute('state', 'active')
         else
           puts "Server not found for ip address #{order.whmapserver.server_ip} #{order.whmapserver.server_name}"
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
  
  desc 'Verify Migration'
  task :verify => :environment do
    
    #balances should be the same
    Account.find(:first).each { |account|
      
    }
    
  end
  
end