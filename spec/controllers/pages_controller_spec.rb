require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  fixtures :users, :pages, :roles, :roles_users

  describe "Anybody" do

    it "should show a page" do
      Page.should_receive(:find).with(100).and_return(Page.new)
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
      user = users(:quentin)
      
      #user.show_receive(:roles).and_return([Role.administrator])
      session[:user_id] = user.id
    end
    
    it "should show all pages" do
      get 'index'
      response.should be_success
    end
    
  end
  
end
