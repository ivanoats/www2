require 'spec_helper'

describe "/passwords/new" do
  before(:each) do
    assigns[:password] = stub_model(Password,:new_record? => false)
    render 'passwords/new'
  end

  it "render" do
    response.should be_success
  end
end
