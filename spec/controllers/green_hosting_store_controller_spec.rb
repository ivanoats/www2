require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module CartSystemHelperSpecMethods
  def should_test_for_new_cart_on(action)
    get action
    
    session[:cart_id].should_not be_nil
    Cart.find(session[:cart_id]).should_not be_nil
    assigns[:cart].id.should == session[:cart_id]
  end
  
  def should_test_for_existing_cart_on(action)
    expected_cart = Cart.create!
    session[:cart_id] = expected_cart.id
    
    get action
    
    session[:cart_id].should == expected_cart.id
    assigns[:cart].id.should == expected_cart.id
  end
end

describe GreenHostingStoreController do
  include CartSystemHelperSpecMethods
  
  it "should use GreenHostingStoreController" do
    controller.should be_an_instance_of(GreenHostingStoreController)
  end


  describe "GET 'choose_domain'" do
    it "should be successful" do
      get 'choose_domain'
      response.should be_success
    end
    
    it "should create a new cart for a new user session" do
      should_test_for_new_cart_on 'choose_domain'
    end
    
    it "should load an existing cart for an previous user session" do
      should_test_for_existing_cart_on 'choose_domain'
    end    
  end

  describe "GET 'choose_package'" do
    it "should be successful" do
      get 'choose_package'
      response.should be_success
    end
    
    it "should create a new cart for a new user session" do
      should_test_for_new_cart_on 'choose_domain'
    end
    
    it "should load an existing cart for an previous user session" do
      should_test_for_existing_cart_on 'choose_domain'
    end
  end

  describe "GET 'choose_addon'" do
    it "should be successful" do
      get 'choose_addon'
      response.should be_success
    end

    it "should create a new cart for a new user session" do
      should_test_for_new_cart_on 'choose_domain'
    end
    
    it "should load an existing cart for an previous user session" do
      should_test_for_existing_cart_on 'choose_domain'
    end
  end
  
  describe 'when an account is required' do
    before(:each) do
      @user = User.new
      @account = Account.new
      @user.accounts << @account
      @user.stubs(:valid?).returns(true)
      @controller.stubs(:current_user).returns(@user)
    end
        
    describe "GET 'checkout'" do
      it "should be successful" do
        get 'checkout'
        response.should be_success
      end
      
      it "should create a new cart for a new user session" do
        should_test_for_new_cart_on 'choose_domain'
      end

      it "should load an existing cart for an previous user session" do
        should_test_for_existing_cart_on 'choose_domain'
      end
    end
  end
  
  describe "GET 'confirmation'" do
    it "should be successful" do
      get 'confirmation'
      response.should be_success
    end
    
    it "should create a new cart for a new user session" do
      should_test_for_new_cart_on 'choose_domain'
    end
    
    it "should load an existing cart for an previous user session" do
      should_test_for_existing_cart_on 'choose_domain'
    end
  end
end
