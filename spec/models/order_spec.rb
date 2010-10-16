require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Order do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    Order.create!(@valid_attributes)
  end


  # TODO:  REPLACE THE MODEL CREATIONS WITH A FIXTUREREPLACEMENT TOOL LIKE FACTORYGIRL OR MACHINIST
  it "should create an order from a cart" do
    
    @product = Product.create!(:name => "Product Name", :description => "a test product", :cost => 7.00, :status => 'active', :kind => 'package')
    @cart_item = CartItem.new(:description => "A test item", :quantity => 1, :product => @product, :name => @product.name)


    @cart = Cart.new
    @cart_item.cart = @cart
    @cart_item.save!

    @cart.add(@product, @product.name)
    
    @order = Order.from_cart(@cart)

    assert @order.purchases.first.product == @product
    
  end

end
