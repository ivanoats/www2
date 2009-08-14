require 'httpclient'
module EnomApi
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def manage_with_enom
      send :include, InstanceMethods
    end
  end
  
  module InstanceMethods
    @@raw_config = File.read(RAILS_ROOT + "/config/enom_config.yml")
    @@enom_config = YAML.load(@@raw_config)[RAILS_ENV].symbolize_keys
    @@url = @@enom_config[:url]
    @@values = {
      'UID' => @@enom_config[:username],
      'PW' => @@enom_config[:password],
      'ResponseType' => "XML"
    }
    
    def expiration_date
      response = api_call('GetDomainExp')
      response['interface_response']['expiration_date'].to_datetime
    end
    
    def nameservers
      response = api_call('GetDNS')
      response['interface_response']['dns'] || []
    end
    
    def nameservers=(nameservers = [])    
      if nameservers == []
        response = api_call('ModifyNS', {'UseDNS' => 'Default'}) #use enom nameservers
      else
        options = {}
        nameservers.each_with_index { |nameserver,index|
          options["NS#{index}"] = nameserver
        }
        response = api_call('ModifyNS', options)
      end
      
      response
    end
    
    def registrant_contact
      get_contact_info_for("Registrant")
    end
    
    def registrant_contact=(contact)
      set_contact_info_for("Registrant", contact)
    end
    
    def billing_contact
      get_contact_info_for("Billing")
    end
    
    def billing_contact=(contact)
      set_contact_info_for("Billing", contact)
    end
    
    def technical_contact
      get_contact_info_for("Technical")  
    end
    
    def technical_contact=(contact)
      set_contact_info_for("Technical", contact)
    end
    
    def administrative_contact
      get_contact_info_for("Administrative")
    end
    
    def administrative_contact=(contact)
      set_contact_info_for("Administrative", contact)  
    end
    
    def locked?
      response = api_call('GetRegLock')
      response['interface_response']['reg_lock'] == '1'
    end
    
    def locked=(locked)
      set_single_item()
    end
    
    def available?
      response = api_call('check')
      !response.has_errors? && response['rrp_code'] == 210
    end
    
    def purchase!(options)
      response = api_call('purchase', options)
      
      #throw response.errors.first if response.has_errors?# && response['rrp_code'] == 210
      
      response
    end
    
    def get_contact_info_for(contact_type)
      response = api_call('GetContacts')
      fields = response['interface_response']['get_contacts'][contact_type]
    
      #fields are prefixed with contact_type and that is silly
      fields.collect! {|key,values|
        new_key = key.gsub("#{contact_type}_",'')
        [new_key,values]
      }
      fields
    end
    
    def set_contact_info_for(contact_type, contact_data)
      
    end
        
    def api_call(enom_command, options = {})
      split = name.split('.')
      sld = split.first
      tld = split.last
      values = @@values.merge({
        'Command' => enom_command,
        'SLD' => sld,
        'TLD' => tld
      }).merge(options)
      
      Response.from_xml(HTTPClient.new.get_content(URI.parse(@@url + values.to_query)))
    end
    
    def domain_exists_in_enom_account?
      response = api_call('GetAllDomains')
      all_domains = response['interface_response']['get_all_domains']['domain_detail']['domain_name']
      unless all_domains.include?(name)
        errors.add_to_base('Domain does not exist in your Enom account.')
      end
    end
  end
  
  class Response < Hash
    def errors
      err_count = self["ErrCount"].to_i
      (1..err_count).map { |err| self["errors"]["Err#{err}"]}
    end
    
    def has_errors?
      !errors.empty?
    end
  end
  
end
ActiveRecord::Base.send :include, EnomApi
