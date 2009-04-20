require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountController do
  
  before(:each) do
    @user = User.new(:accounts => [Account.new])
    @controller.stubs(:current_user).returns(@user)
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
      put 'create', {:organization => "Test 22"}, {:user_id => 30}
      response.should redirect_to(:action => :manage)
    end
  end
  
  describe 'edit' do
    it 'should work' do
      get 'edit', {}, {:user_id => 30}
      response.should be_success
    end
  end
  
  describe 'update' do
    it 'should work' do
      @account.expects(:update_attributes).returns(true)
      put 'update', {}, {:user_id => 30}
      response.should redirect_to(:action => :manage)
    end
  end
  
  describe 'manage' do
    it 'should work' do
      get 'manage', {}, {:user_id => 30}
      response.should be_success
    end
  end

  describe 'payments' do
    it 'should work' do
      get 'payments', {}, {:user_id => 30}
      response.should be_success
    end
  end

  describe 'hosting' do
    it 'should work' do
      get 'hosting', {}, {:user_id => 30}
      response.should be_success
    end
  end
  
  describe 'billing' do
    it 'should work' do
      get 'billing', {}, {:user_id => 30}
      response.should be_success
    end
    
    it "should update billing" do
      post 'billing', {}
      
      credit_card = mock('cc')
      credit_card.expects(:valid?).returns(true)
      ActiveMerchant::Billing::CreditCard.stubs(:new).returns(credit_card)
      
      @account.expects(:store_card).returns(true)
      
      response.should redirect_to(:action => "billing")
    end
  end
  
end
