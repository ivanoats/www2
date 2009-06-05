class CartController < ApplicationController
  include CartSystem
  
  before_filter :load_cart, :only => [:add_domain, :add_package, :add_addon, :remove_cart_item]
  
  def add_domain
    # pull in the cart from the session
    load_cart

    # add it to cart
    @cart.add(Product.domain, params[:domain], {:domain => params[:domain]})
    
    render :update do |page|
      page.redirect_to :controller => :green_hosting_store, :action => :choose_package
    end
  end

  def add_package
    @product = Product.find(params[:id])
    @hosting = Hosting.new(params[:hosting])
    @hosting.product = @product
    if @hosting.valid?
      @cart.add(@product,@product.name,params[:hosting])
      render :update do |page|
        page.redirect_to :controller => :green_hosting_store, :action => :choose_addon
      end
    else
      render :update do |page|
        page.replace_html 'error_messages_for_hosting', error_messages_for(:hosting) 
      end
    end
  end
  
  def add_addon
    @product = Product.find(params[:id])
    @cart.add(@product,@product.name)
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
