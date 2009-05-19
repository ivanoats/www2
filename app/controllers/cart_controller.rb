class CartController < ApplicationController
  include CartSystem
  
  before_filter :load_cart, :only => [:add_domain, :add_package, :add_addon, :remove_cart_item]
  
  def index
    @cart = Cart.new
  end

  def add_domain
    # pull in the cart from the session
    load_cart

    # add it to cart
    @cart.add(Product.domain, 1, nil, {:domain => params[:domain][:name]})
    
    # render the cart items
    render_cart
  end

  def add_package
    @product = Product.find(params[:package_id])
    @cart.add(@product)
    render_cart
  end
  
  def add_addon
    @product = Product.find(params[:addon_id])
    @cart.add(@product)
    render_cart
  end


  def remove_cart_item
    @cart.remove(params[:id])
    render_cart
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
