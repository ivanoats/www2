require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  
  before(:each) do
    @valid_attributes = {
      :title => "PageTest",  
      :body => "stub for page test"
    }
  end

  it "should create a new Page given valid attributes" do
    @page = Page.create!(@valid_attributes)
    @page.should be_valid
  end
  
  it "should have a permalink should be based on the title" do
    @page = Page.create!(@valid_attributes)
    @page.permalink.should == "pagetest"
  end
  
  it "should have a valid title" do
    @page = Page.create!(@valid_attributes)
    @page.title.should == "PageTest"
  end
end

