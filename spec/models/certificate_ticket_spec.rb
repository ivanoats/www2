require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CertificateTicket do
  before(:each) do
    @valid_attributes = {
      :email => "test@example.com",
      :host => "www.babelfish.com", 
      :country => "US", 
      :state => "MN", 
      :city => "Minneapolis", 
      :company_name => "Evil Inc.", 
      :company_division => "main", 
      :password => "pwd"
    }
  end

  it "should create a new instance given valid attributes" do
    CertificateTicket.create!(@valid_attributes)
  end
end
