class CartController < ApplicationController
  include CartSystem
  
  def index
    @cart = Cart.new
  end

  def add_domain
    
    # create product
    
    @product_attributes = {
      :name            => params[:domain][:name],
      :description     => "Domain registration",
      :cost            => 10.00,
      :recurring_month => 0,
      :status          => "active",
      :kind            => "domain"
    }
    @product = Product.create!(@product_attributes)
    
    # pull in the cart from the session
    load_cart

    # add it to cart
    @cart.add(@product)
    
    # render the cart items
    render_cart
  end

  def add_package
    @product = Product.find(params[:package_id])
    load_cart
    @cart.add(@product)
    render_cart
  end
  
  def add_addon
    @product = Product.find(params[:addon_id])
    load_cart
    @cart.add(@product)
    render_cart
  end


  def remove_cart_item
  end

  def change_cart_item_quantity
  end

  private
  
  # updates the cart via rjs and html
  def render_cart
    render :update do |page|
      page.replace_html("cart", :partial => "cart/items", :object => @cart)
    end #update    
  end

end
