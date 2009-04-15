require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Product do
  before(:each) do
    @valid_attributes = {
      :name            => "Basic Web Hosting",
      :description     => "1,000MB Storage, 10,000MB Bandwidth, Unlimited Emails, Unlimited Addons, Fantastico",
      :cost            => 1000,
      :recurring_month => 1,
      :status          => "active",
      :kind            => "package"
    }
  end

  it "should create a new instance given valid attributes" do
    Product.create!(@valid_attributes)
  end
  
  it "should require a name" do
    lambda { Product.create!(@valid_attributes.merge(:name => '')) }.should raise_error
  end
  
  it "should only allow cost as an integer" do
    lambda { Product.create!(@valid_attributes.merge(:cost => '')) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:cost => 0.99)) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:cost => 1)) }.should_not raise_error
  end
  
  it "should only allow cost greater than 0" do
    lambda { Product.create!(@valid_attributes.merge(:cost => 0)) }.should raise_error
  end
    
  it "should have a list of status" do
    Product::STATUS.should == %w(active disabled)
  end
  
  it "should include only valid choices for status" do
    Product::STATUS.each do |expected|
      lambda { Product.create!(@valid_attributes.merge(:status => expected)) }.should_not raise_error
    end
    
    lambda { Product.create!(@valid_attributes.merge(:status => 'cool!')) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => 1)) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => true)) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => false)) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => nil)) }.should raise_error
  end
  
  it "should have a list of kinds" do
    Product::KINDS.should == %w(package add-on)
  end
  
  it "should include only valid choises for kind" do
    Product::KINDS.each do |expected|
      lambda { Product.create!(@valid_attributes.merge(:kind => expected)) }.should_not raise_error
    end
    
    lambda { Product.create!(@valid_attributes.merge(:status => 'cool!')) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => 1)) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => true)) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => false)) }.should raise_error
    lambda { Product.create!(@valid_attributes.merge(:status => nil)) }.should raise_error
  end
end
