require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cart do
  before(:each) do
    @valid_attributes = {
      :referrer_id => 1,
      :session_id => "value for session_id"
    }
  end

  it "should create a new instance given valid attributes" do
    Cart.create!(@valid_attributes)
  end
end
