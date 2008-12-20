require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/redirects/index.html.erb" do
  include RedirectsHelper
  
  before(:each) do
    assigns[:redirects] = [
      stub_model(Redirect,
        :slug => "slug1",
        :url => "http://www.google.com",
        :notes => "value for notes"
      ),
      stub_model(Redirect,
        :slug => "slug2",
        :url => "http://www.yahoo.com",
        :notes => "value for notes"
      )
    ]
  end

  it "should render list of redirects" do
    render "/redirects/index.html.erb"
    response.should have_tag("tr>td", "slug1", 2)
    response.should have_tag("tr>td", "http://www.google.com", 2)
    response.should have_tag("tr>td", "value for notes", 2)
  end
end

