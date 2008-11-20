require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/products/index.html.erb" do
  include ProductsHelper
  
  before(:each) do
    assigns[:products] = [
      stub_model(Product,
        :name => "value for name",
        :price_dollars => "1",
        :price_cents => "1"
      ),
      stub_model(Product,
        :name => "value for name",
        :price_dollars => "1",
        :price_cents => "1"
      )
    ]
  end

  it "should render list of products" do
    render "/products/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

