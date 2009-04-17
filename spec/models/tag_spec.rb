require File.dirname(__FILE__) + '/../spec_helper'

describe Tag do
  before(:each) do
    @valid_attributes = {
      :name => "tag1",
      :description => "this is the tag description"
    }
  end
  
  it "should create a new Tag given valid attributes" do
    @tag = Tag.create!(@valid_attributes)
    @tag.should be_valid
  end
  
  it "should output tag description" do
    @tag = Tag.create!(@valid_attributes)
    @tag.description.should == "this is the tag description"
  end
  
  it "should require a name" do
    lambda { Product.create!(@valid_attributes.merge(:name => '')) }.should raise_error
  end
  
  
end