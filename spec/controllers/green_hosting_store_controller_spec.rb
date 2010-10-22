require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include ActiveMerchant::Billing

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
  
  def mock_cart
    cart = mock('cart')
    cart.stubs({:cart_items => [mock_cart_item, mock_cart_item]})
    cart
  end
  
  def mock_cart_item
    cart_item = mock('cart_item')
    cart_item.stubs({:product => Product.new, :quantity => 1})
    cart_item
  end
  
  def cart_in_session
    Cart.stubs(:find_by_id).with(1).returns(mock_cart)
    {:cart_id => 1}
  end
end

describe GreenHostingStoreController do
  include CartSystemHelperSpecMethods
  
  it "should use GreenHostingStoreController" do
    controller.should be_an_instance_of(GreenHostingStoreController)
  end
  
  describe 'GET index' do
    it 'should redirect to choose_package' do
      get 'index'
      response.should redirect_to(:action => :choose_package)
    end
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
  end

  describe "GET 'choose_addon'" do
    it "should be successful" do
      #pending ("write a proper test for addons that sets up a cart")
      get 'choose_addon', {}, cart_in_session
      response.should be_success
    end

  end
  
  describe 'when not logged in ' do
    describe 'GET checkout' do
      it "should not continue if cart is empty" do
        get 'checkout'
        response.should redirect_to(:action => :choose_package)
      end
      
      it 'should show checkout' do 
        get 'checkout', {}, cart_in_session
        response.should be_success
      end
    end
    
    describe 'POST checkout' do
      before(:each) do
        @new_user_params = {'fish' => :donkey}
        @new_account_params = {'alligator' => :turtle}
      
        @user = User.new
        @user.stubs(:valid?).returns(true)
        User.expects(:new).with(@new_user_params).returns(@user)
      
        @account = Account.new
        @account.stubs(:valid?).returns(true)
        Account.expects(:new).with(@new_account_params).returns(@account)
      end
      
      it 'should create a new user and account' do      
        post 'checkout', {:user => @new_user_params, :account => @new_account_params}, cart_in_session
        response.should redirect_to( :action => :billing)  
      end
    end
  end
  
  describe 'without an account' do
    
    describe 'GET checkout' do
      it 'should be successful' do
        @user = User.new
        @controller.stubs(:current_user).returns(@user)
        
        get 'checkout', {}, cart_in_session
        response.should be_success
      end
    end
  end
  
  describe 'with an account' do
    before(:each) do
      @user = User.new
      @account = Account.new
      @user.accounts << @account
      @user.stubs(:valid?).returns(true)
      @controller.stubs(:current_user).returns(@user)
    end
        
    describe "GET 'checkout'" do
      it "should be successful" do
        get 'checkout', {}, cart_in_session
        response.should be_success
      end
      
      it "should create a new cart for a new user session" do
        should_test_for_new_cart_on 'choose_domain'
      end

      it "should load an existing cart for an previous user session" do
        should_test_for_existing_cart_on 'choose_domain'
      end
    end
    
    describe 'GET billing' do
      it 'should be successful' do
        get 'billing', {}, cart_in_session
        response.should be_success
      end
    end
    
    describe 'POST billing' do
      it 'should use an existing card' do
        post 'billing', {:use_existing_credit_card => 1}, cart_in_session
        response.should redirect_to( :action => :confirmation )
      end
      
      it 'should store a credit card' do
        @account_params = {}
        @address_params = {}
        
        @address = mock('address')
        @account = mock('account', {:billing_address => @address })
        Account.expects(:find_by_id).returns(@account)
        @credit_card = mock("cc")
        CreditCard.expects(:new).returns(@credit_card)
        @address.expects(:update_attributes).returns(true)
        @account.expects(:update_attributes).returns(true)
        @credit_card.expects(:valid?).returns(true)
        @account.expects(:store_card).returns(true)
        
        post 'billing', {:account => @account_params, :address => @address_params}, cart_in_session.merge({:account => 1})
        
        response.should redirect_to( :action => :confirmation )
      end
    end
    
    describe "GET 'confirmation'" do
      it "should be successful" do
        get 'confirmation', {}, cart_in_session
        response.should be_success
      end
    end
    
    describe 'POST payment' do
      it 'should be successful' do
        @order = mock('order', {:account= => true, :save => true, :reload => true})
        Order.expects(:from_cart).returns(@order)
        OrderMailer.expects(:deliver_admin_notification).with(@order)
        OrderMailer.expects(:deliver_complete)
        
        @account = mock('account')
        Account.expects(:find_by_id).returns(@account)
        @account.expects(:charge_order).with(@order).returns(true)

        post 'payment', {}, cart_in_session.merge(:account => 1)
        response.should have_been_redirect
        response.should redirect_to( :action => 'thanks' )
      end
    end
    
    describe 'GET thanks' do
      it 'should be successful' do
        get 'thanks'
        response.should be_success
      end
    end
  end
end
