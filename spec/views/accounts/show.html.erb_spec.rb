require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/accounts/show.html.erb" do
  include AccountsHelper
  before(:each) do
    assigns[:account] = @account = stub_model(Account)
  end

  it "renders attributes in <p>" do
    render
  end
end

