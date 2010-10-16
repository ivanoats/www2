require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'ap'

describe Order do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    Order.create!(@valid_attributes)
  end
  
  it "should create an order from a cart" do
    
    puts '<pre>'
    
    @product = Product.new(:name => "Product Name", :cost => 7.00, :status => 'active', :kind => 'package')
    puts 'product: '
    ap @product
    
    @cart_item = CartItem.new(:description => "A test item", :quantity => 1, :product => @product)
    puts 'cart_item: '
    ap @cart_item
        
    @cart = Cart.new(:cart_items => [@cart_item])
    puts 'cart: '
    ap @cart
    
    @order = Order.from_cart(@cart)
    puts 'order: '
    ap @order
    
    puts 'purchases.first: '
    ap @order.purchases.first    
    assert @order.purchases.first.product == @product
    
    puts '</pre>'
  end

end
