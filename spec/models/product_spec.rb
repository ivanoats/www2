require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Product do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :cost => 1.5,
      :recurring_period => 1,
      :status => "value for status",
      :type => "value for type"
    }
  end

  it "should create a new instance given valid attributes" do
    Product.create!(@valid_attributes)
  end
end
