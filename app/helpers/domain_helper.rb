module DomainHelper
  
  require 'universal_ruby_whois'
  # gem is here: git://github.com/mlightner/universal_ruby_whois.git
  # also http://agilewebdevelopment.com/plugins/universal_whois_client
  # requires the dig and whois commands installed on the server
   module ClassMethods
    
    def expiration_date(domain_name)
      Whois.find(domain_name).expiration_date
    end
    
    def status(domain_name)
      Whois.find(domain_name).status
    end
    
    def available?(domain_name)
      Whois.find(domain_name).available?
    end
    
    def registered?(domain_name)
      Whois.find(domain_name).registered?
    end
  
    def nameservers(domain_name)
      dig_output = `dig #{domain_name} NS +short`
      dig_output.split
    end
   
    def a_record(domain_name)
      `dig #{domain_name} A +short`.split
    end
    
    def mx_records(domain_name)
      `dig #{domain_name} MX +short`.split
    end
    
  end
  
  module InstanceMethods
    
  end
    
    def self.included(base)
      super
      base.extend         ClassMethods
#      receiver.extend         InstanceMethods
#      receiver.send :include, InstanceMethods
    end
    
end