class Cart < ActiveRecord::Base
  validates_numericality_of :referrer_id, :only_integer => true, :greater_than => 0, :allow_nil => true

  has_many :cart_items

  # Adds a +Product+ to itself as a +CartItem+. You can customize the quanity and quantity units
  # with arguments. Returns the newly built +CartItem+.
  def add(product, name, data = {}, parent = nil, quantity = 1, quantity_unit = nil )
    cart_item_attributes = {
      :product_id          => product.id,
      :cart_id             => self.id,
      :name                => name,
      :description         => product.description,
      :unit_price          => product.cost,
      :quantity            => quantity,
      :quantity_unit       => quantity_unit,
      :data                => data,
      :parent              => parent
      
    }
    cart_items.create!(cart_item_attributes)  #TODO test database creation of the record
  end

  # Removes a +CartItem+ from itself given an id.  Returns the destroyed, frozen +CartItem+.
  #
  # ==== Arguments
  # * <tt>cart_item_id</tt> - A +CartItem+ id.
  #
  # ==== Example
  # remove(12)  #=> A destroyed and frozen +CartItem+.
  def remove(cart_item_id)
    cart_item = cart_items.find_by_id(cart_item_id)
    cart_item.destroy
  end

  # Changes the +quantity+ of a +CartItem+ give an id.  Returns the modified +CartItem+.
  #
  # ==== Arguments
  # * <tt>cart_item_id</tt> - A +CartItem+ id.
  # * <tt>quantity</tt>     - Sets the quantity of the +CartItem+ (removes the +CartItem+ from the cart if 0).
  #
  # ==== Example
  # change_quantity(12, 69)  #=> A modified +CartItem+ with a quantity of 69.
  def change_quantity(cart_item_id, quantity)
    return remove(cart_item_id) if quantity == 0

    cart_item = cart_items.find_by_id(cart_item_id)
    index     = cart_items.index(cart_item)

    cart_item[:quantity] = quantity

    cart_items[index] = cart_item
    cart_item
  end
  
  def total_price
    cart_items.inject(0) do |total,cart_item|
      total += cart_item.unit_price * cart_item.quantity
    end
  end
end
