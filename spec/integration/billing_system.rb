require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BillingSystem do
  include BillingSystem
  before(:each) do
    @user = create_user
    @product = create_product(:name => "Magic Hosting", :cost => 12.50, :status => 'active', :kind => 'package')

  end
  
  describe "An account is due" do
    before(:each) do
      @account = create_account(:last_payment_on => 1.month.ago, :users => [@user], :hostings => [create_hosting(:product => @product)], :state => 'active', :balance => -100)
      Account.stubs(:active).returns(mock('active', {:due => [@account], :overdue => []}))
    end
    
    it "should deliver a payment success message" do
      @account.expects(:charge_balance).returns(true)
      BillingMailer.expects(:deliver_charge_success)        
      accounts
    end
    
    it "should deliver a payment failed message" do
      @account.expects(:charge_balance).returns(false)
      BillingMailer.expects(:deliver_charge_failure)        
      accounts
    end
  
  end
  
  describe "An account is overdue" do
    before(:each) do
      @account = create_account(:last_payment_on => (1.month + 1.day).ago, :users => [@user], :hostings => [create_hosting(:product => @product)], :state => 'active', :balance => -100)
      Account.stubs(:active).returns(mock('active', {:overdue => [@account], :due => []}))
      
    end

    it "should deliver a payment success message" do
      @account.expects(:charge_balance).returns(true)
      BillingMailer.expects(:deliver_charge_success)        
      accounts
    end
    
    it "should deliver a payment failed message" do
      @account.expects(:charge_balance).returns(false)
      BillingMailer.expects(:deliver_charge_failure)        
      accounts
    end
  end
  
  describe "An account is 5 days overdue" do
    before(:each) do
      @account = create_account(:last_payment_on => (1.month + 5.days).ago, :users => [@user], :hostings => [create_hosting(:product => @product)])
      Account.stubs(:active).returns(mock('active', {:overdue => [@account], :due => []}))
      
    end
  
    it "should deliver a payment success message" do
      @account.expects(:charge_balance).returns(true)
      BillingMailer.expects(:deliver_charge_success)        
      accounts
    end
    
    it "should suspend the account" do
      @account.expects(:charge_balance).returns(false)
      @account.hostings.first.expects(:suspend!)        
      accounts
    end
  end
  
end
