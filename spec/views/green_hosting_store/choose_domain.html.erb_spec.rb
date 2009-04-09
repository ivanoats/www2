require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/green_hosting_store/choose_domain" do
  before(:each) do
    render 'green_hosting_store/choose_domain'
  end
  
  #Delete this example and add some real ones or delete this file
  it "should tell you where to find the file" do
    response.should have_tag('p', %r[Find me in app/views/green_hosting_store/choose_domain])
  end
end
