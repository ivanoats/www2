require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Product do
  before(:each) do
    @valid_attributes = {
      :name            => "Basic Web Hosting",
      :description     => "1,000MB Storage, 10,000MB Bandwidth, Unlimited Emails, Unlimited Addons, Fantastico",
      :cost            => 10.00,
      :recurring_month => 1,
      :status          => "enabled",
      :kind            => "package"
    }
  end

  it "should create a new instance given valid attributes" do
    Product.create!(@valid_attributes)
  end
  
  it "should require a name" do
    lambda { Product.create!(@valid_attributes.merge(:name => '')) }.should raise_error
  end
  
  it "should only allow cost as a number" do
    lambda { Product.create!(@valid_attributes.merge(:cost => '')) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:cost => 0.99)) }.should_not raise_error
    lambda { Product.create!(@valid_attributes.merge(:cost => 1)) }.should_not raise_error
  end
  
  it "should only allow cost greater or equal to 0" do
    lambda { Product.create!(@valid_attributes.merge(:cost => 0)) }.should_not raise_error
  end
  
  it "should only allow positive costs" do
    lambda { Product.create!(@valid_attributes.merge(:cost => -10 ))}.should raise_error
  end
    
  it "should have a list of status" do
    Product::STATUS.should == %w(enabled disabled)
  end
  
  # TODO:  IS THIS TEST USEFUL?   WE'RE TESTING CONSTANTS...
  it "should include only valid choices for status" do
    Product::STATUS.each do |expected|
      lambda { Product.create!(@valid_attributes.merge(:status => expected)) }.should_not raise_error
    end
    
    lambda { Product.create!(@valid_attributes.merge(:status => 'cool!')) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => 1)) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => true)) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => nil)) }.should_not raise_error
  end
  
  # TODO: IS THIS TEST USEFUL? 
  it "should have a list of kinds" do
    Product::KINDS.should == %w(package domain addon coupon)
  end
  
  it "should include only valid choices for kind" do
    Product::KINDS.each do |expected|
      lambda { Product.create!(@valid_attributes.merge(:kind => expected)) }.should_not raise_error
    end
    
    lambda { Product.create!(@valid_attributes.merge(:status => 'cool!')) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => 1)) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => true)) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => nil)) }.should_not raise_error
  end
  
  it "should find all packages" do
    Product::KINDS.each do |kind|
      Product.create!(@valid_attributes.merge(:kind => kind))
    end
        
    expected = Product.packages
    expected.first.kind.should == 'package'    
  end
  
  it "should find all addons" do
    Product::KINDS.each do |kind|
      Product.create!(@valid_attributes.merge(:kind => kind))
    end
  
    expected = Product.addons
    expected.first.kind.should == 'addon'  
  end
end
