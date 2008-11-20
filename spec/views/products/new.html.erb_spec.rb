require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/products/new.html.erb" do
  include ProductsHelper
  
  before(:each) do
    assigns[:product] = stub_model(Product,
      :new_record? => true,
      :name => "value for name",
      :price_dollars => "1",
      :price_cents => "1"
    )
  end

  it "should render new form" do
    render "/products/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", products_path) do
      with_tag("input#product_name[name=?]", "product[name]")
      with_tag("input#product_price_dollars[name=?]", "product[price_dollars]")
      with_tag("input#product_price_cents[name=?]", "product[price_cents]")
    end
  end
end


