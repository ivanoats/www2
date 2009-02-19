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
  
  it "should test for basic format of an email address without getting too trixie" do

    CertificateTicket.new(@valid_attributes.merge(:email => 'a@b.c')).should be_valid
    CertificateTicket.new(@valid_attributes.merge(:email => 'a+b@b.c')).should be_valid
    CertificateTicket.new(@valid_attributes.merge(:email => 'abcdefghijk@b.c.e.f.g')).should be_valid

    CertificateTicket.new(@valid_attributes.merge(:email => '@b.c')).should_not be_valid
    CertificateTicket.new(@valid_attributes.merge(:email => 'a@b')).should_not be_valid
    CertificateTicket.new(@valid_attributes.merge(:email => 'a.c')).should_not be_valid
    CertificateTicket.new(@valid_attributes.merge(:email => 'a')).should_not be_valid

  end
end
