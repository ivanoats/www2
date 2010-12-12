require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CartController do

  # def add_domain
  #     if(params[:package_id]) #if package_id is specified then add a package with the domain
  #       @package = Product.packages.enabled.find(params[:package_id])
  #       hosting = @cart.add(@package, @package.name)
  #       @cart.add(Product.domain, params[:domain], {:domain => params[:domain]},hosting)
  #       render :update do |page|
  #         page.redirect_to :controller => :green_hosting_store, :action => :choose_addon, :id => hosting
  #       end
  #     end
  #     return
  #   end

  before(:each) do 
    @cart = Cart.new
    Cart.expects(:find_by_id).returns(@cart)
  end
  
  it 'should get add_domain' do
    
    @hosting_product = Product.make
    @hosting = mock()
    @cart.expects(:add).twice
    Product.expects(:domain)
    Product.expects(:find).with('1').returns(@hosting_product)
    
    
    get 'add_domain', {:package_id => 1, :domain => 'www.domain.com'}, {:cart_id => 1}
    response.should include_text("window.location.href = \"/green_hosting_store/choose_addon\";")
  end
  
  it 'should get edit_domain' do
    @hosting_product = Product.make
    @domain_product = Product.make(:kind => 'domain')
    
    @hosting_cart_item = CartItem.make(:product => @hosting_product)
    @domain_cart_item = CartItem.make(:product => @domain_product)
    @hosting_cart_item.children << @domain_cart_item
    @cart.cart_items << @hosting_cart_item
    @cart.expects(:add)    
    @cart.save!    

    get 'edit_domain', {:domain => 'fish.edu', :id => @hosting_cart_item.id}, {:cart_id => 1}
    response.should have_been_redirect
    response.should redirect_to( :controller => :green_hosting_store, :action => :edit_hosting, :id => @hosting_cart_item.id )
  end
  
  it 'should get edit_domain when purchased' do
    @hosting_product = Product.make
    @domain_product = Product.make(:kind => 'domain')
    
    @hosting_cart_item = CartItem.make(:product => @hosting_product)
    @domain_cart_item = CartItem.make(:product => @domain_product)
    @hosting_cart_item.children << @domain_cart_item
    @cart.cart_items << @hosting_cart_item
    @cart.expects(:add)    
    @cart.save!    

    get 'edit_domain', {:domain => 'fish.edu', :id => @hosting_cart_item.id, :purchased => true}, {:cart_id => 1}
    response.should include_text("window.location.href = \"/green_hosting_store/edit_hosting/#{@hosting_cart_item.id}\";")
  end
  
  it 'should get add_package' do
    @hosting_product = Product.make
    @hosting = mock(:to_param => 1)
    @cart.expects(:add).twice.returns(@hosting)
    Product.expects(:find).returns(@hosting_product)
    Product.expects(:free_domain).returns()
    get 'add_package', {:package_id => 1, :domain => 'www.domain.com'}, {:cart_id => 1}
    
    response.should have_been_redirect
    response.should redirect_to(:controller => :green_hosting_store, :action => :choose_addon, :id => 1)
    
  end
  
  it 'should get edit_package' do
    @hosting_product = Product.make(:name => 'Old')
    @new_hosting_product = Product.make(:name => 'New')
    @new_hosting_product.save!
    @hosting_cart_item = CartItem.make(:product => @hosting_product)
    @hosting_cart_item.expects("update_attributes")
    @cart.cart_items << @hosting_cart_item
    @cart.save!
    
    CartItem.expects(:find).with {|first,second| first.to_i == @hosting_cart_item.id }.returns( @hosting_cart_item ).at_least_once
    CartItem.expects(:find).with {|first,second| first == :all}.returns([])
    
    get 'edit_package', {:id => @hosting_cart_item.id, :package_id => @new_hosting_product.id}, {:cart_id => 1}

    response.should have_been_success
    response.should render_template('cart/_items')
  end
  
  it 'should get add_addon' do
    @hosting_product = Product.make
    @add_on_product = Product.make(:kind => 'addon')
    @hosting_cart_item = CartItem.make(:product => @hosting_product)
    @cart.cart_items << @hosting_cart_item
    @cart.save!
    @cart.expects('add')
    
    get 'add_addon', {:id => @add_on_product.id, :package_id => @hosting_cart_item.id}, {:cart_id => 1}
    response.should have_been_success
    response.should render_template('cart/_items')
  end
  
  it "should get remove_addon" do
    @hosting_product = Product.make
    @add_on_product = Product.make(:kind => 'addon')
    
    @hosting_cart_item = CartItem.make(:product => @hosting_product)
    @add_on_cart_item = CartItem.make(:product => @add_on_product)
    @hosting_cart_item.children << @add_on_cart_item
    @cart.cart_items << @hosting_cart_item
    @cart.save!  
    
    @cart.expects("remove").with(@add_on_cart_item.id)
      
    get 'remove_addon', {:package_id => @hosting_cart_item.id, :id => @add_on_product.id }, {:cart_id => 1}
    response.should have_been_success
    response.should render_template('cart/_items')
  end


  it "should get remove_cart_item" do
    @cart.expects(:remove).with('2')

    get 'remove_cart_item', {:id => 2}, {:cart_id => 1}
    response.should be_success
    response.should render_template('cart/_items')
    
  end


end
