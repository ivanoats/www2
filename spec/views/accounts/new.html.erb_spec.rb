require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/new.html.erb" do
  include AccountsHelper
  
  before(:each) do
    assigns[:account] = stub_model(Account,
      :new_record? => true
    )
  end

  it "renders new account form" do
    render
    
    response.should have_tag("form[action=?][method=post]", accounts_path) do
    end
  end
end


