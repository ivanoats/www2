require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @valid_attributes = {
      
    }
    @more_attributes = @valid_attributes.merge({
      :first_name => "John",
      :last_name => "Brown",
      :organization => "Abolitionists Inc.",
      :billing_address => Address.new({
        :street => "1234 Lane Ln",
        :city => "Montgomery",
        :state => "Alabama",
        :country => "USA"
      })
    })
  end

  it "should create a new instance given valid attributes" do
    Account.create!(@valid_attributes)
  end
  
  it "should save a credit card" do
    @account = Account.new(@more_attributes)
    @credit_card = ActiveMerchant::Billing::CreditCard.new(
      :first_name => 'Steve', 
      :last_name  => 'Smith', 
      :month      => '9', 
      :year       => '2010', 
      :type       => 'visa', 
      :number     => '4242424242424242'
    )
    
    gateway = mock('gateway')
    response = mock('response').stubs(:success?).returns(true)
    gateway.stubs(:update_credit_card_profile).returns(response)
    gateway.stubs(:create_customer_profile).returns(response)
    @account.stubs(:authorize_net_cim_gateway).returns(gateway)
    assert @account.store_card(@credit_card)
  end
  
  
  it "should always have a balance" do
    @account = Account.new(@valid_attributes)
    assert_equal @account.balance, 0
  end
  
  
  describe "when making a fake purchase" do
    
    before(:each) do
      @account = Account.create(@more_attributes)
      
      @gateway = mock('gateway')
      @response = mock('response')
      @response.stubs(:success?).returns(true)
      @gateway.stubs(:purchase).returns(@response)
      
      @account.stubs(:gateway).returns(@gateway)
    end
  
    it "should make an arbitrary charge" do
      @response.expects(:authorization).returns("YOU ARE SO AUTHORIZED")
      assert @account.charge(13.25)
    end

    it "should have errors on a failed charge" do
      @response.stubs(:success?).returns(false)
      @response.expects(:message).returns("FAILURE IS ALWAYS AN OPTION")
      assert_equal @account.charge(13.25), false
      assert_equal @account.errors.on_base, "FAILURE IS ALWAYS AN OPTION"
    end

    it "should charge an order" do
      @response.expects(:authorization).returns("AUTHORIZED")
      @order = Order.new
      @order.stubs(:total_charge_in_pennies).returns(1325)
      @order.expects(:paid!)
      assert @account.charge_order(@order)
    end
    
    it "should charge an order and fail" do
      @response.stubs(:success?).returns(false)
      @response.expects(:message).returns("ERRRR")
      @order = Order.new
      @order.stubs(:total_charge_in_pennies).returns(1325)
      assert !@account.charge_order(@order)
      assert_equal @order.errors.on_base, "ERRRR"
    end
    
  end
  
  
  describe "when the balance is not negative" do
    it "should not be due for payment" do
      account = create_account(:balance => 0, :last_payment_on => 32.days.ago)
      assert_equal Account.payment_due, []
    end
  end
  
  describe "when the balance is negative and payment was over a month ago" do
    it "should be due for payment" do
      account = create_account(:balance => -1000, :last_payment_on => 32.days.ago)
      assert_equal Account.payment_due, [account]
    end
  end
  
  describe "when the balance is negative and payment was over a year ago" do
    it "should be due for payment" do
      account = create_account(:balance => -1000, :last_payment_on => 366.days.ago)
      assert_equal Account.payment_due, [account]
    end
  end
  
  describe "when the balance is negative and payment was within a month" do
    it "should not be due for payment" do
      account = create_account(:balance => -1000, :last_payment_on => 25.days.ago)
      assert_equal Account.payment_due, []
    end
  end
    
  
  
  # it "should run a live test - this should be somewhere else" do
  #     @account = Account.new(@more_attributes)
  #     @credit_card = ActiveMerchant::Billing::CreditCard.new(
  #       :first_name => 'Steve', 
  #       :last_name  => 'Smith', 
  #       :month      => '9', 
  #       :year       => '2010', 
  #       :type       => 'visa', 
  #       :number     => '4242424242424242'
  #     )
  # 
  #     @account.store_card(@credit_card)
  #     @order = Order.new(:purchases => [Purchase.new(:product => Product.new(:name => "Product Name", :cost_in_cents => 700, :status => 'active', :kind => 'package'))])
  #     assert @account.charge_order(@order)
  #   end
end