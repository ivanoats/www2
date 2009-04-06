require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Customer do
  before(:each) do
    @valid_attributes = {
      :first_name => "value for first_name",
      :last_name => "value for last_name",
      :organization => "value for organization",
      :address_1 => "value for address_1",
      :address_2 => "value for address_2",
      :city => "value for city",
      :state => "value for state",
      :country => "value for country",
      :phone => "value for phone",
      :user_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Customer.create!(@valid_attributes)
  end
end
