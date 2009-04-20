class Cart < ActiveRecord::Base
  validates_numericality_of :referrer_id, :only_integer => true, :greater_than => 0, :allow_nil => true

  has_many :cart_items

  # Adds a +Product+ to itself as a +CartItem+. You can customize the quanity and quantity units
  # with arguments. Returns the newly built +CartItem+.
  #
  # ==== Arguments
  # * <tt>product</tt>        - A +Product+ object (required).
  # * <tt>quantity</tt>       - Sets quantity of the product (defaults to 1).
  # * <tt>quantity_units</tt> - Sets quantity units of the product (defaults to +nil+).
  #
  # ==== Examples
  # add(product)                #=> A new +CartItem+.
  # add(product, 94)            #=> A new +CartItem+ with a quantity of 94.
  # add(product, 12, "months")  #=> A new +CartItem+ with a quanity of 12 and quantity_units of "months".
  def add(product, quantity = 1, quantity_unit = nil)
    cart_item_attributes = {
      :product_id          => product.id,
      :cart_id             => self.id,
      :description         => "#{product.name}\n{#{product.description}}",
      :unit_price_in_cents => product.cost,
      :quantity            => quantity,
      :quantity_unit       => quantity_unit
    }
    cart_items.build(cart_item_attributes)
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
end
