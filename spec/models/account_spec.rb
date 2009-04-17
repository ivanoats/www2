require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
    @valid_attributes = {
      
    }
    @more_attributes = @valid_attributes.merge({
      :first_name => "John",
      :last_name => "Brown",
      :organization => "Abolitionists Inc.",
      :address_1 => "1234 Lane Ln",
      :city => "Montgomery",
      :state => "Alabama",
      :country => "USA"
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
    @account.save_credit_card(@credit_card)
  end
  
  it "should run a live test - this should be somewhere else" do
    @account = Account.new(@more_attributes)
    @credit_card = ActiveMerchant::Billing::CreditCard.new(
      :first_name => 'Steve', 
      :last_name  => 'Smith', 
      :month      => '9', 
      :year       => '2010', 
      :type       => 'visa', 
      :number     => '4242424242424242'
    )

    @account.save_credit_card(@credit_card)
    pp @account.credit_card
    @order = Order.new(:purchases => [Purchase.new(:product => Product.new(:name => "Product Name", :cost => 700, :status => 'active', :kind => 'package'))])
    response = @account.authorized?(@order)
    @account.pay(@order,reponse) if response.success?
  end
end


def authorized?(order)
  gateway = authorize_net_gateway #self.paypal? ? paypal_gateway : authorize_net_gateway
  amount = self.total_charge_in_pennies
  response = gateway.authorize(amount, self.credit_card, {:address => '',:ip => '127.0.0.1'}.merge!(purchase_tracking))
  
end

def pay(order, authorization)
  throw "Cannot pay order with bad authorization" unless response.success?
  gateway = authorize_net_gateway
  gateway.capture(amount, reponse.authorization)
  order.paid!
end