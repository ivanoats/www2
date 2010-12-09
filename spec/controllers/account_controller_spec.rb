require ('spec_helper')
include ActiveMerchant::Billing

describe AccountController do

  before(:each) do
    @user = User.new()
    @account = Account.new(:organization => 'Ok')
    @user.accounts << @account
    @user.stubs(:valid?).returns(true)
    @controller.stubs(:current_user).returns(@user)
  end
  
  describe 'index' do
    it 'should work' do
      get 'index', {}, {:user_id => 30}
      response.should be_success
    end
  end
  
  describe "new" do
    it "should work" do
      User.stubs(:find).returns(User.create(:accounts => [Account.new]))
      get 'new', {}, {:user_id => 30}
      response.should be_success
    end
  end
  
  describe 'create' do
    it 'should create a new account for the current user' do
      put 'create', {:account => {:organization => "Test 22"}}, {:user_id => 30}
      response.should have_been_redirect
      response.should redirect_to(:action => :manage)
    end
    
    it 'should show errors for an invalid account' do
      @account.stubs(:save).returns(false)
      Account.expects(:new).returns(@account)
      put 'create', {}, {}
      response.should be_success
      response.should render_template('new')
    end
  end
  
  describe 'edit' do
    it 'should work' do
      get 'edit', {}, {:user_id => 30}
      response.should be_success
    end
  end
  
  describe 'update' do
    it 'should work and redirect to the account/manage page' do
      @account.expects(:update_attributes).returns(true)
      put 'update', {}, {:user_id => 30}
      response.should redirect_to(:action => :manage)
    end
    
    it 'should show errors for an invalid account' do
      @account.stubs(:save).returns(false)
      Account.expects(:find_by_id).returns(@account)
      put 'update', {}, {}
      response.should be_success
      response.should render_template('edit')
    end
  end
  
  describe 'manage' do
    it 'should work' do
      get 'manage', {}, {:user_id => 30}
      response.should be_success
    end
  end

  describe 'hosting' do
    it 'should work' do
      get 'hosting', {}, {:user_id => 30}
      response.should be_success
    end
  end
  
  describe 'account switching' do
    it 'should switch if administrator' do
      @user = User.new
        @user.expects(:has_role?).with('Administrator').returns(true)
      @controller.stubs(:current_user).returns(@user)
      
      get 'switch_account', {:id => 1}, {:user_id => 30}
      response.should be_success
      session['account'].should == '1'
    end
    
    it 'should switch if account owner' do
      Account.stubs(:find_by_id).returns(@account)

      get 'switch_account', {:id => 1}, {:user_id => 30}
      response.should be_success
      session['account'].should == '1'
    end
    
    it 'should not switch if not account owner' do
      @user = User.new
      @controller.stubs(:current_user).returns(@user)
      Account.stubs(:find_by_id).returns(@account)
      get 'switch_account', {:id => 1}, {:user_id => 31}
      response.should be_success
      session['account'].should == nil
    end
  end
  
  describe 'order' do
    it 'should show an order' do
      @order = Order.new
      Order.expects(:find).returns(@order)
      get 'order', {:id => 1}
      
      response.should be_success
      
    end
  end
  
  describe 'billing info' do


    
    it "should update billing info" do
      credit_card = mock('cc')
      credit_card.stubs(:valid?).returns(true)
      CreditCard.stubs(:new).returns(credit_card)
      
      @account.expects(:store_card).returns(true)
      
      post 'billing', {:user_id => 30}
      response.should have_been_redirect
      response.should redirect_to(:action => "edit", :anchor => "billing_tab")
    end
    
    it 'should show an error when updating fails' do
      credit_card = mock('cc')
      credit_card.stubs(:valid?).returns(true)
      CreditCard.stubs(:new).returns(credit_card)
      
      @account.expects(:store_card).returns(false)
      
      post 'billing', {:user_id => 30}
      flash[:notice].should == "Failed to store credit card."
      response.should have_been_redirect
      response.should redirect_to(:action => "edit", :anchor => "billing_tab")
    end
      
  end
  
  describe 'payments' do
    it 'should GET payments page' do
      get 'payments', {}, {:user_id => 30}
      response.should be_success
    end
    
    it "should GET pay page" do
      @account.expects(:needs_payment_info?).returns(false)

      get 'pay', {}, {:user_id => 30}
      response.should be_success
    end
    
    it 'should require payment info' do
      @account.expects(:needs_payment_info?).returns(true)
      get 'pay', {}, {:user_id => 30}
      response.should have_been_redirect
      response.should redirect_to(:action => 'edit', :anchor => 'billing_tab')      
    end
    
    it 'should make a payment' do
      @account.expects(:charge).with(10).returns(true)
      @account.expects(:needs_payment_info?).returns(false)
      post 'pay', {:amount => '10'}, {:user_id => 30}
      response.should have_been_redirect
      response.should redirect_to(:action => 'payments')
    end
    
    it 'should show an error message' do
      @account.expects(:charge).with(10).returns(false)
      @account.expects(:needs_payment_info?).returns(false)
      post 'pay', {:amount => '10'}, {:user_id => 30}
      response.should be_success      
    end
  end
  
end
