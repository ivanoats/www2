class Product < ActiveRecord::Base
  STATUS = %w(active disabled)
  KINDS = %w(package add-on)
  
  validates_presence_of :name
  validates_numericality_of :cost, :greater_than => 0, :only_integer => true
end
