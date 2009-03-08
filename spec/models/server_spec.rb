require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Server do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :ip_address => "value for ip_address",
      :vendor => "value for vendor",
      :location => "value for location",
      :primary_ns => "value for primary_ns",
      :primary_ns_ip => "value for primary_ns_ip",
      :secondary_ns => "value for secondary_ns",
      :secondary_ns_ip => "value for secondary_ns_ip",
      :max_accounts => 1,
      :whm_user => "value for whm_user",
      :whm_pass => "value for whm_pass",
      :whm_key => "value for whm_key"
    }
  end

  it "should create a new instance given valid attributes" do
    Server.create!(@valid_attributes)
  end
end
