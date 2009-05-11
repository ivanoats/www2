class Domain < ActiveRecord::Base
  belongs_to :account
  belongs_to :product
  
  manage_with_enom
  

end
