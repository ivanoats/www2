class Role < ActiveRecord::Base
  
  #TODO memoize in 2.2
  
  def self.administrator
    Role.find_or_create_by_name("Administrator")
  end
  
  def self.editor
    Role.find_or_create_by_name("Editor")
  end
  
  def self.customer
    Role.find_or_create_by_name("Customer")
  end
  
  def self.staff
    Role.find_or_create_by_name("Staff")
  end
end