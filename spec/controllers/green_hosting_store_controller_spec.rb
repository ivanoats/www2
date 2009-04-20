require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GreenHostingStoreController do

  #Delete these examples and add some real ones
  it "should use GreenHostingStoreController" do
    controller.should be_an_instance_of(GreenHostingStoreController)
  end


  describe "GET 'choose_domain'" do
    it "should be successful" do
      get 'choose_domain'
      response.should be_success
    end
    
    it "should create a new cart for a new user session" do
      get 'choose_domain'
      session[:cart_id].should_not be_nil
      Cart.find(session[:cart_id]).should_not be_nil
      assigns[:cart].id.should == session[:cart_id]
    end
    
    it "should find an existing cart for an previous user session" do
      expected_cart = Cart.create!
      session[:cart_id] = expected_cart.id
      get 'choose_domain'
      session[:cart_id].should == expected_cart.id
      assigns[:cart].id.should == expected_cart.id
    end
    
  end

  describe "GET 'choose_package'" do
    it "should be successful" do
      get 'choose_package'
      response.should be_success
    end
  end

  describe "GET 'choose_addon'" do
    it "should be successful" do
      get 'choose_addon'
      response.should be_success
    end
  end

  describe "GET 'checkout'" do
    it "should be successful" do
      get 'checkout'
      response.should be_success
    end
  end

  describe "GET 'confirmation'" do
    it "should be successful" do
      get 'confirmation'
      response.should be_success
    end
  end
end
