class CartItems < ActiveRecord::Base
  belongs_to :cart
  has_one :product
end
