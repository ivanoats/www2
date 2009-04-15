require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CartItem do
  before(:each) do
    @valid_attributes = {
      :product_id          => 1,
      :cart_id             => 1,
      :description         => "Basic Web Hosting\n1,000MB Storage, 10,000MB Bandwidth, Unlimited Emails, Unlimited Addons, Fantastico",
      :unit_price_in_cents => 1000,
      :quantity            => 1,
      :quantity_unit       => "month"
    }
  end

  it "should create a new instance given valid attributes" do
    CartItem.create!(@valid_attributes)
  end
  
  it "should belong to a cart"
  
  it "should have one product"
  
  it "should require a description" do
    lambda { CartItem.create!(@valid_attributes.merge(:description => '')) }.should raise_error
  end

  it "should only allow unit_price_in_cents as an integer" do
    lambda { CartItem.create!(@valid_attributes.merge(:unit_price_in_cents => '')) }.should raise_error
    lambda { CartItem.create!(@valid_attributes.merge(:unit_price_in_cents => 0.99)) }.should raise_error
    lambda { CartItem.create!(@valid_attributes.merge(:unit_price_in_cents => 1)) }.should_not raise_error
  end  
  
  it "should only allow unit_price_in_cents greater than or equal to 0" do
    lambda { CartItem.create!(@valid_attributes.merge(:unit_price_in_cents => 0)) }.should_not raise_error
  end
  
  it "should only allow quantity as an integer" do
    lambda { CartItem.create!(@valid_attributes.merge(:quantity => '')) }.should raise_error
    lambda { CartItem.create!(@valid_attributes.merge(:quantity => 0.99)) }.should raise_error
    lambda { CartItem.create!(@valid_attributes.merge(:quantity => 1)) }.should_not raise_error
  end
  
  it "should only allow quantity greater than 0" do
    lambda { CartItem.create!(@valid_attributes.merge(:quantity => 0)) }.should raise_error
  end
  
end
