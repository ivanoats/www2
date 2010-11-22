require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/index.html.erb" do
  
  
  before(:each) do
    assigns[:objects] = [
      stub_model(Account),
      stub_model(Account)
    ]
    assigns[:objects].stubs(:total_pages).returns(1)
    assigns[:headings] = [['Organization', 'organization'], ['Status','state'],['Email','email']]
    
  end

  it "renders a list of accounts" do
    render
  end
end

