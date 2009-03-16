module DomainHelper
  
  require 'universal_ruby_whois'
  # gem is here: git://github.com/mlightner/universal_ruby_whois.git
  # also http://agilewebdevelopment.com/plugins/universal_whois_client
  # requires the dig and whois commands installed on the server
  
    
    def nameservers(domain_name)
      dig_output = `dig #{domain_name} NS +short`
      dig_output.split
    end
    
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
    
end