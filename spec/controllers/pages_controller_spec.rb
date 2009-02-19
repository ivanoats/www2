require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  fixtures :users, :pages, :roles, :roles_users
  
  def mock_page(stubs={})
    @page ||= mock_model(Page, stubs)
  end
  
  describe "Anybody" do

    it "should show a page" do
      Page.should_receive(:find).with('100').and_return(Page.new)
      get 'show', :id => 100
      response.should be_success
    end
    
    it "should show the home page" do
      Page.should_receive(:find).and_return(Page.new)
      get 'home'
      response.should be_success
    end
    
    it "should show by permalink" do
      page = pages(:one)
      get 'permalink', :permalink => page.permalink
      response.should be_success
    end
  end
  
  describe "Administrator" do
    before :each do
      login_as(:quentin)
    end
    
    describe "responding to GET index" do

      it "should expose all pages as @pages" do
        Page.should_receive(:find).with(:all).and_return([mock_page])
        get :index
        assigns[:pages].should == [mock_page]
      end

    end
    
    describe "responding to DELETE destroy" do

       it "should destroy the requested page" do
         Page.should_receive(:find).with("37").and_return(mock_page)
         mock_page.should_receive(:destroy)
         delete :destroy, :id => "37"
       end

       it "should redirect to the pages list" do
         Page.stub!(:find).and_return(mock_page(:destroy => true))
         delete :destroy, :id => "1"
         response.should redirect_to(pages_url)
       end
     end
    
  end
  
end
