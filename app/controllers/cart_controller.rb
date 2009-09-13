class CartController < ApplicationController
  include CartSystem
  
  before_filter :load_cart, :only => [:add_domain, :add_package, :add_addon, :remove_cart_item]
  
  def add_domain
    if(params[:package_id])
      @package = Product.packages.enabled.find(params[:package_id])
      
      hosting = @cart.add(@package, @package.name, {:domain => params[:domain][:name]})
      @cart.add(Product.domain, params[:domain][:name], {:domain => params[:domain][:name]},hosting)
      redirect_to :controller => :green_hosting_store, :action => :choose_addon, :id => hosting
    else
      @cart.add(Product.domain, params[:domain][:name], {:domain => params[:domain][:name]})      
      redirect_to :controller => :green_hosting_store, :action => :choose_hosting
      
    end
    return
  end

  def add_package
    @product = Product.packages.enabled.find(params[:id])
    
    hosting = @cart.add(@product,"#{@product.name} (#{params[:domain]})",{:domain => params[:domain]})
    redirect_to :controller => :green_hosting_store, :action => :choose_addon, :id => hosting
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
