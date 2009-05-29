require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/servers/show.html.erb" do
  
  before(:each) do
    assigns[:server] = @server = stub_model(Server,
      :name => "value for name",
      :ip_address => "value for ip_address",
      :vendor => "value for vendor",
      :location => "value for location",
      :primary_ns => "value for primary_ns",
      :primary_ns_ip => "value for primary_ns_ip",
      :secondary_ns => "value for secondary_ns",
      :secondary_ns_ip => "value for secondary_ns_ip",
      :max_accounts => 1,
      :whm_user => "value for whm_user",
      :whm_pass => "value for whm_pass",
      :whm_key => "value for whm_key"
    )
  end

  it "should render attributes in <p>" do
    render "/servers/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ ip_address/)
    response.should have_text(/value\ for\ vendor/)
    response.should have_text(/value\ for\ location/)
    response.should have_text(/value\ for\ primary_ns/)
    response.should have_text(/value\ for\ primary_ns_ip/)
    response.should have_text(/value\ for\ secondary_ns/)
    response.should have_text(/value\ for\ secondary_ns_ip/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ whm_user/)
    response.should have_text(/value\ for\ whm_pass/)
    response.should have_text(/value\ for\ whm_key/)
  end
end

