class CartController < ApplicationController
  include CartSystem
  
  before_filter :load_cart, :only => [:add_domain, :edit_domain, :add_package, :add_addon, :remove_addon, :remove_cart_item, :edit_package]
  
  def add_domain
    if(params[:package_id]) #if package_id is specified then add a package with the domain
      @package = Product.packages.enabled.find(params[:package_id])
      hosting = @cart.add(@package, @package.name)
      @cart.add(Product.domain, params[:domain], {:domain => params[:domain]},hosting)
      render :update do |page|
        page.redirect_to :controller => :green_hosting_store, :action => :choose_addon, :id => hosting
      end
    end
    return
  end
  
  def edit_domain
    hosting = @cart.cart_items.find(params[:id])
    hosting.domain.destroy if hosting.domain
    if params[:purchased]
      @cart.add(Product.domain, params[:domain], {:domain => params[:domain]},hosting)      
      render :update do |page|
        page.redirect_to :controller => :green_hosting_store, :action => :edit_hosting, :id => hosting
      end
    else
      @cart.add(Product.free_domain, params[:domain], {:domain => params[:domain]},hosting)      
      redirect_to :controller => :green_hosting_store, :action => :edit_hosting, :id => hosting
    end
  end

  def add_package
    @product = Product.packages.enabled.find(params[:package_id])
    
    hosting = @cart.add(@product,@product.name,{:domain => params[:domain]})
    @cart.add(Product.free_domain, params[:domain], {:domain => params[:domain]},hosting)
    redirect_to :controller => :green_hosting_store, :action => :choose_addon, :id => hosting
  end
  
  def edit_package
    hosting = @cart.cart_items.find(params[:id])
    product = Product.packages.enabled.find(params[:package_id])
    hosting.update_attributes({
      :product => product,
      :name => product.name,
      :description => product.description,
      :unit_price => product.cost
    })
    render_cart
  end
  
  def add_addon
    @product = Product.find(params[:id])
    cart_item = @cart.cart_items.find(params[:package_id])
    unless cart_item.products.include?(@product)
      @cart.add(@product,@product.name, {}, cart_item)
    end
    render_cart
  end

  def remove_addon
    @package = @cart.cart_items.find(params[:package_id])
    add_on = @package.children.find(:first, :include => :product, :conditions => ["product_id = ?",params[:id]])
    @cart.remove(add_on.id)
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
