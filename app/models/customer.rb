class Customer < ActiveRecord::Base
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :organization
  validates_presence_of :address_1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :country
  validates_presence_of :phone
  
  # Relationships
  belongs_to :user
end
