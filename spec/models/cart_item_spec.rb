require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CartItem do
  before(:each) do
    @valid_attributes = {
      :product_id          => 1,
      :cart_id             => 1,
      :name                => "Basic Web Hosting",
      :description         => "1,000MB Storage, 10,000MB Bandwidth, Unlimited Emails, Unlimited Addons, Fantastico",
      :unit_price          => 10.00,
      :quantity            => 1,
      :quantity_unit       => "month"
    }
  end

  it "should create a new instance given valid attributes" do
    CartItem.create!(@valid_attributes)
  end
  
  it "should belong to a cart" do
    association_results = {
      :macro      => :belongs_to,
      :class_name => "Cart"
    }
    CartItem.reflect_on_association(:cart).to_hash.should == association_results
  end
  
  it "should belong to a product" do
    association_results = {
      :macro      => :belongs_to,
      :class_name => "Product"
    }
    CartItem.reflect_on_association(:product).to_hash.should == association_results
  end
  
  it "should require a name" do
    lambda { CartItem.create!(@valid_attributes.merge(:name => '')) }.should raise_error
  end
  
  it "should require a description" do
    lambda { CartItem.create!(@valid_attributes.merge(:description => '')) }.should raise_error
  end

  it "should only allow unit_price as a decimal" do
    lambda { CartItem.create!(@valid_attributes.merge(:unit_price => '')) }.should raise_error
    lambda { CartItem.create!(@valid_attributes.merge(:unit_price => 0.99)) }.should_not raise_error
    lambda { CartItem.create!(@valid_attributes.merge(:unit_price => 1)) }.should_not raise_error
  end  
  
  it "should only allow unit_price greater than or equal to 0" do
    lambda { CartItem.create!(@valid_attributes.merge(:unit_price => 0)) }.should_not raise_error
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
