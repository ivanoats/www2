require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hosting do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    Hosting.create!(@valid_attributes)
  end
  
  describe "when the fee was last charged over a month ago for monthly billing" do
    it "should be due for feeing" do
      hosting = create_hosting(:last_charge_on => 32.days.ago, :charge_period => 'monthly')
      assert_equal Hosting.fee_due, [hosting]
    end
  end
  
  describe "when the fee was last charged less than a month ago for monthly billing" do
    it "should not be due for feeing" do
      hosting = create_hosting(:last_charge_on => 25.days.ago, :charge_period => 'monthly')
      assert_equal Hosting.fee_due, []
    end
  end
  
  describe "when the fee was last charged over a month ago for yearly billing" do
    it "should be due for feeing" do
      hosting = create_hosting(:last_charge_on => 366.days.ago, :charge_period => 'yearly')
      assert_equal Hosting.fee_due, [hosting]
    end
  end
  
  describe "when the fee was last charged less than a month ago for yearly billing" do
    it "should not be due for feeing" do
      hosting = create_hosting(:last_charge_on => 364.days.ago, :charge_period => 'yearly')
      assert_equal Hosting.fee_due, []
    end
  end
  
end


