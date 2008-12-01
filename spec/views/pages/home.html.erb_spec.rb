require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "A home page" do
  fixtures :pages
  before(:each) do
    assigns[:page] = Page.create(:title => 'test_for_title', :body => 'body of home page')
  end
  
  it "should show the home page" do
    render "/pages/home.html.erb"
    response.should include_text('test_for_title')
  end
end

