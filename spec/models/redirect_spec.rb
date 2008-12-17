require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Redirect do
  before(:each) do
    @valid_attributes = {
      :slug => "value for slug",
      :url => "value for url",
      :notes => "value for notes"
    }
  end

  it "should create a new instance given valid attributes" do
    Redirect.create!(@valid_attributes)
  end
end
