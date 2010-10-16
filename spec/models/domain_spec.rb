require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Domain do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :monitor_resolve => false,
      :resolved => false,
      :expires_on => Time.now
    }
  end
  # TODO real test needed for domains with FixtureReplacement or Machinist etc
  # it "should create a new instance given valid attributes" do
  #   Domain.create!(@valid_attributes)
  # end
end
