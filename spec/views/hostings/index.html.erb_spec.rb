require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hostings/index.html.erb" do
  include HostingsHelper
  
  before(:each) do
    assigns[:hostings] = [
      stub_model(Hosting),
      stub_model(Hosting)
    ]
  end

  it "renders a list of hostings" do
    render
  end
end

