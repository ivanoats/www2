class CartItem < ActiveRecord::Base
  validates_presence_of :name, :description
  validates_numericality_of :unit_price_in_cents, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :quantity, :only_integer => true, :greater_than => 0
  
  belongs_to :cart
  has_one :product
end
