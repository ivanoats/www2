require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Payment Success' do
  before(:all) do
    @account = create_account(:email => 'something@example.com')
    @payment = Payment.new(:amount => 125.78, :receipt => 'whatever is here')
    @email = BillingMailer.create_charge_success(@account, @payment)
  end

  it "should be set to be delivered to the email passed in" do
    @email.should deliver_to('something@example.com')
  end

  it "should contain the user's message in the mail body" do
    @email.should have_text(@payment.receipt)
  end

  it "should have the correct subject" do
    @email.should have_subject('Sustainable Websites Payment Receipt')
  end

end

describe 'Payment Failure' do
  before(:all) do
    @account = create_account(:email => 'something@example.com')
    @amount = 392.55
    @email = BillingMailer.create_charge_failure(@account, @amount)
  end

  it "should be set to be delivered to the email passed in" do
    @email.should deliver_to('something@example.com')
  end

  it "should contain the user's message in the mail body" do
    @email.should have_body_text('$392.55')
  end

  it "should have the correct subject" do
    @email.should have_subject('Sustainable Websites Payment Failed')
  end

end
