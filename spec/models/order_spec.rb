require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Order do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    Order.create!(@valid_attributes)
  end
  
  it "should create an order from a cart" do
    
    @product = Product.new(:name => "Product Name", :cost => 7.00, :status => 'active', :kind => 'package')
    
    @cart = Cart.new(:cart_items => [CartItem.new(:description => "A test item", :quantity => 1, :product => @product)])
    @order = Order.from_cart(@cart)
    
    assert @order.purchases.first.product == @product
  end

  it "should create a invoice number" do
    Order.expects(:generate_invoice_number).returns(7)
    order = Order.create(@valid_attributes)
    assert_equal order.invoice_number, 7
  end
end
