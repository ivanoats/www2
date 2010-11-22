require 'spec_helper'

describe "/passwords/reset" do
  before(:each) do
    assigns[:user] = stub_model(User)
    render 'passwords/reset'    
  end

  it "should render" do
    response.should be_success
  end
end
