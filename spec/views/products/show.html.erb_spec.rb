require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/products/show.html.erb" do
  include ProductsHelper
  
  before(:each) do
    assigns[:product] = @product = stub_model(Product,
      :name => "value for name",
      :price_dollars => "1",
      :price_cents => "1"
    )
  end

  it "should render attributes in <p>" do
    render "/products/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end

