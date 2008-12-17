require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/redirects/show.html.erb" do
  include RedirectsHelper
  
  before(:each) do
    assigns[:redirect] = @redirect = stub_model(Redirect,
      :slug => "value for slug",
      :url => "value for url",
      :notes => "value for notes"
    )
  end

  it "should render attributes in <p>" do
    render "/redirects/show.html.erb"
    response.should have_text(/value\ for\ slug/)
    response.should have_text(/value\ for\ url/)
    response.should have_text(/value\ for\ notes/)
  end
end

