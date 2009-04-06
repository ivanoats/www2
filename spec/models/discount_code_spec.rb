require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DiscountCode do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :percent_off => 1,
      :status => "value for status",
      :expiration_date => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    DiscountCode.create!(@valid_attributes)
  end
end
