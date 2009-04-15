class CartItem < ActiveRecord::Base
  validates_presence_of :description
  validates_numericality_of :unit_price_in_cents, :greater_than_or_equal_to => 0, :only_integer => true
  validates_numericality_of :quantity, :greater_than => 0, :only_integer => true
  
  belongs_to :cart
  has_one :product
end
