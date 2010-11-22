require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/products/index.html.erb" do
  
  
  before(:each) do
    assigns[:objects] = [
      stub_model(Product),
      stub_model(Product)
    ]
    assigns[:objects].stubs(:total_pages).returns(1)
    assigns[:headings] = [['Name', 'name'], ['Kind','kind'], ['Status','status']]
    
  end

  it "renders a list of products" do
    render
  end
end

