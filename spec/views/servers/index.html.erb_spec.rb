require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/servers/index.html.erb" do
  
  
  before(:each) do
    assigns[:servers] = [
      stub_model(Server,
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
      ),
      stub_model(Server,
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
    ]
  end

  it "should render list of servers" do
    render "/servers/index.html.erb"
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for ip_address".to_s, 2)
    response.should have_tag("tr>td", "value for vendor".to_s, 2)
    response.should have_tag("tr>td", "value for location".to_s, 2)
  end
end

