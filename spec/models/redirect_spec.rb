require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Redirect do
  before(:each) do
    @valid_attributes = {
      :slug => "slug",
      :url => "http://www.google.com",
      :notes => "value for notes"
    }
  end

  it "should create a new instance given valid attributes" do
    Redirect.create!(@valid_attributes)
  end
end
