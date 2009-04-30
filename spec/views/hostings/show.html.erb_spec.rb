require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hostings/show.html.erb" do
  include HostingsHelper
  before(:each) do
    assigns[:hosting] = @hosting = stub_model(Hosting)
  end

  it "renders attributes in <p>" do
    render
  end
end

