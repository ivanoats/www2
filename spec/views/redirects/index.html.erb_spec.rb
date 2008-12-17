require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/redirects/index.html.erb" do
  include RedirectsHelper
  
  before(:each) do
    assigns[:redirects] = [
      stub_model(Redirect,
        :slug => "value for slug",
        :url => "value for url",
        :notes => "value for notes"
      ),
      stub_model(Redirect,
        :slug => "value for slug",
        :url => "value for url",
        :notes => "value for notes"
      )
    ]
  end

  it "should render list of redirects" do
    render "/redirects/index.html.erb"
    response.should have_tag("tr>td", "value for slug", 2)
    response.should have_tag("tr>td", "value for url", 2)
    response.should have_tag("tr>td", "value for notes", 2)
  end
end

