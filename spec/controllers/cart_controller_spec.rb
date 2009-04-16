require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CartController do

  #Delete these examples and add some real ones
  it "should use CartController" do
    controller.should be_an_instance_of(CartController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'add_product'" do
    it "should be successful" do
      get 'add_product'
      response.should be_success
    end
  end

  describe "GET 'remove_cart_item'" do
    it "should be successful" do
      get 'remove_cart_item'
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
