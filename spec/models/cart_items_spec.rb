require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CartItems do
  before(:each) do
    @valid_attributes = {
      :product_id => 1,
      :cart_id => 1,
      :description => "value for description",
      :unit_price => 1.5,
      :quantity => 1,
      :quantity_unit => "value for quantity_unit"
    }
  end

  it "should create a new instance given valid attributes" do
    CartItems.create!(@valid_attributes)
  end
end
