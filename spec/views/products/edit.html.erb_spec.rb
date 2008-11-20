require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/products/edit.html.erb" do
  include ProductsHelper
  
  before(:each) do
    assigns[:product] = @product = stub_model(Product,
      :new_record? => false,
      :name => "value for name",
      :price_dollars => "1",
      :price_cents => "1"
    )
  end

  it "should render edit form" do
    render "/products/edit.html.erb"
    
    response.should have_tag("form[action=#{product_path(@product)}][method=post]") do
      with_tag('input#product_name[name=?]', "product[name]")
      with_tag('input#product_price_dollars[name=?]', "product[price_dollars]")
      with_tag('input#product_price_cents[name=?]', "product[price_cents]")
    end
  end
end


