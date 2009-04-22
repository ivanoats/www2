class CartController < ApplicationController
  include CartSystem
  
  def index
    @cart = Cart.new
  end

  # generic add product
  # def add_product
  #   
  #   # create product
  #   
  #   @product_attributes = {
  #     :name            => params[:domain][:name],
  #     :description     => "Domain registration",
  #     :cost_in_cents            => 1000,
  #     :recurring_month => 0,
  #     :status          => "active",
  #     :kind            => "package"
  #   }
  #   @product = Product.new(@product_attributes)
  # 
  #   # pull in the cart from the session
  #   load_cart
  # 
  #   # add it to cart
  #   @cart.add(@product)
  #   
  #   # render the cart items
  #   render :update do |page|
  #     page.replace_html("cart", :partial => "cart/items", :object => @cart)
  #   end
  # end

  def add_domain
    
    # create product
    
    @product_attributes = {
      :name            => params[:domain][:name],
      :description     => "Domain registration",
      :cost_in_cents            => 1000,
      :recurring_month => 0,
      :status          => "active",
      :kind            => "package"
    }
    @product = Product.new(@product_attributes)

    # pull in the cart from the session
    load_cart

    # add it to cart
    @cart.add(@product)
    
    # render the cart items
    render :update do |page|
      page.replace_html("cart", :partial => "cart/items", :object => @cart)
    end
  end

  def add_package
    # create product
    @product = Product.find(params[:package_id])
    
    # pull in the cart from the session
    load_cart

    # add it to cart
    @cart.add(@product)
    
    # render the cart items
    render :update do |page|
      page.replace_html("cart", :partial => "cart/items", :object => @cart)
    end
  end


  def remove_cart_item
  end

  def change_cart_item_quantity
  end

end
