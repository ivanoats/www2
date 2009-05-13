class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product

  serialize :data, Hash

  validates_presence_of :name, :description
  validates_numericality_of :unit_price, :greater_than_or_equal_to => 0
  validates_numericality_of :quantity, :only_integer => true, :greater_than => 0  
end
