
class Server < ActiveRecord::Base
  has_many :hostings
  
  def whm
    Whm::Server.new(:host => self.ip_address, :username => self.whm_user,:password => self.whm_pass)
  end
  
  def select_description
    "#{self.name} (#{self.ip_address})"
  end
  
end