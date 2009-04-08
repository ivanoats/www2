require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Product do
  before(:each) do
    @valid_attributes = {
      :name => "Basic Web Hosting",
      :description => "1,000MB Storage, 10,000MB Bandwidth, Unlimited Emails, Unlimited Addons, Fantastico",
      :cost => 1000,
      :recurring_month => 1,  #months
      :status => "active",  # [active|disabled]
      :type => "package"
    }
  end

  it "should create a new instance given valid attributes" do
    Product.create!(@valid_attributes)
  end
  
  it "should require a name" do
    lambda { Product.create!(@valid_attributes.reject{|key, value| key == :name }  ) }.should raise_error
  end
  
  it "should require a cost" do
    lambda { Product.create!(@valid_attributes.reject{|key, value| key == :cost }  ) }.should raise_error
  end

end
