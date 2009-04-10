require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AddOn do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should create a new instance given valid attributes" do
    AddOn.create!(@valid_attributes)
  end
end
