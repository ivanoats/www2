require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hostings/edit.html.erb" do
  include HostingsHelper
  
  before(:each) do
    assigns[:hosting] = @hosting = stub_model(Hosting,
      :new_record? => false
    )
  end

  it "renders the edit hosting form" do
    render
    
    response.should have_tag("form[action=#{hosting_path(@hosting)}][method=post]") do
    end
  end
end


