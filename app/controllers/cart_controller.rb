class CartController < ApplicationController
  def index
    @cart = Cart.new
  end

  def add_product
    
    # create product
    
    @product_attributes = {
      :name            => params[:domain][:name],
      :description     => "Domain registration",
      :cost            => 1000,
      :recurring_month => 0,
      :status          => "active",
      :kind            => "package"
    }
    @product = Product.new(@product_attributes)
    @cart = Cart.new
    # pull in the cart from the session
    
    # add it to cart
    @cart.add(@product)
    
    # render the cart items
    render 'cart/items'
  end

  def remove_cart_item
  end

  def change_cart_item_quantity
  end

end
