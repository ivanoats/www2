require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/servers/new.html.erb" do
  include ServersHelper
  
  before(:each) do
    assigns[:server] = stub_model(Server,
      :new_record? => true,
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

  it "should render new form" do
    render "/servers/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", servers_path) do
      with_tag("input#server_name[name=?]", "server[name]")
      with_tag("input#server_ip_address[name=?]", "server[ip_address]")
      with_tag("input#server_vendor[name=?]", "server[vendor]")
      with_tag("input#server_location[name=?]", "server[location]")
      with_tag("input#server_primary_ns[name=?]", "server[primary_ns]")
      with_tag("input#server_primary_ns_ip[name=?]", "server[primary_ns_ip]")
      with_tag("input#server_secondary_ns[name=?]", "server[secondary_ns]")
      with_tag("input#server_secondary_ns_ip[name=?]", "server[secondary_ns_ip]")
      with_tag("input#server_max_accounts[name=?]", "server[max_accounts]")
      with_tag("input#server_whm_user[name=?]", "server[whm_user]")
      with_tag("input#server_whm_pass[name=?]", "server[whm_pass]")
      with_tag("textarea#server_whm_key[name=?]", "server[whm_key]")
    end
  end
end


