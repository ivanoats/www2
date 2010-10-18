require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CartController do

  # describe "GET 'add_product'" do
  #   it "should be successful" do
  #     get 'add_product'
  #     response.should be_success
  #   end
  # end

  describe "GET 'remove_cart_item'" do
    it "should be successful" do
#  Cart.stubs(:create!).returns(mock('cart', {:cart_items => [],:remove => true})) # TODO use mocks eventually
      @cart = Cart.create!
      @product = Product.create!(:name => 'test product', :kind => "package", :status => 'active', :cost => '10', :description => 'a test product description')
      @cart.add @product, @product.name
      # put cart in session, to avoid creating a brand new cart
      session[:cart_id] = @cart.id
      get 'remove_cart_item', :id => @cart.cart_items.first.id
      response.should be_success
    end
  end

  describe "GET 'change_cart_item_quantity'" do
    it "should be successful" do
      get 'change_cart_item_quantity'
      response.should be_success
    end
  end
end
