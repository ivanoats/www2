require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/redirects/index.html.erb" do
  
  
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
    response.should have_tag("tr>td", "slug1")
    # TODO the selector needs to be fixed --> some light research into assert_select
    # response.should have_tag("tr>td", "http://www.google.com")
    # response.should have_tag("tr>td", "value for notes")
  end
end

