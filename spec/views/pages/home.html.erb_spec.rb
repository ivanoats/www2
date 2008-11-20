require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "A home page" do
  
  before(:each) do
    @page = Page.create(:title => 'title', :body => 'body of home page')
  end
  
  it "should show the home page" do
    render "/pages/home.html.erb"
    response.should be_valid
  end
end

