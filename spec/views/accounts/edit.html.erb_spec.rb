require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/edit.html.erb" do
  include AccountsHelper
  
  before(:each) do
    assigns[:account] = @account = stub_model(Account,
      :new_record? => false
    )
  end

  it "renders the edit account form" do
    render
    
    response.should have_tag("form[action=#{account_path(@account)}][method=post]") do
    end
  end
end


