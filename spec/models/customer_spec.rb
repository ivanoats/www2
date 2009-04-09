require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Customer do
  before(:each) do
    @valid_attributes = {
      :first_name   => "Barack",
      :last_name    => "Obama",
      :organization => "The Executive Office of the President of the United States",
      :address_1    => "1600 Pennsylvania Ave NW",
      :address_2    => "Unit \#123",
      :city         => "Washington",
      :state        => "District of Columbia",
      :country      => "United States of America",
      :phone        => "(202) 456-1111",
      :user_id      => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Customer.create!(@valid_attributes)
  end
  
  it "should require first_name" do
    lambda { Customer.create!(@valid_attributes.merge(:first_name => '')) }.should raise_error
  end

  it "should require last_name" do
    lambda { Customer.create!(@valid_attributes.merge(:last_name => '')) }.should raise_error
  end

  it "should require address_1" do
    lambda { Customer.create!(@valid_attributes.merge(:address_1 => '')) }.should raise_error
  end

  it "should require city" do
    lambda { Customer.create!(@valid_attributes.merge(:city => '')) }.should raise_error
  end

  it "should require state" do
    lambda { Customer.create!(@valid_attributes.merge(:state => '')) }.should raise_error
  end

  it "should require country" do
    lambda { Customer.create!(@valid_attributes.merge(:country => '')) }.should raise_error
  end

  it "should require phone" do
    lambda { Customer.create!(@valid_attributes.merge(:phone => '')) }.should raise_error
  end
  
  it "should belong to a user"
end
