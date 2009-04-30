require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/hostings/new.html.erb" do
  include HostingsHelper
  
  before(:each) do
    assigns[:hosting] = stub_model(Hosting,
      :new_record? => true
    )
  end

  it "renders new hosting form" do
    render
    
    response.should have_tag("form[action=?][method=post]", hostings_path) do
    end
  end
end


