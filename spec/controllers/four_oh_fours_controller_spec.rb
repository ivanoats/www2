require File.dirname(__FILE__) + '/../spec_helper'

describe FourOhFoursController do
  
  it "should route unknown urls here" do
    params_from(:get, "/magic_article").should == { :controller => "four_oh_fours", :action => "index", :path=>["magic_article"] }
  end
  
  describe "Anybody" do

    it "should spell something wrong" do
      get 'index', :path => ["magic_article"]
      response.should redirect_to(articles_path(:search => 'magic_article'))
    end
    
    it "should request a page by name" do
      page = mock(Page)
      Page.should_receive(:find_by_permalink).and_return(Page.new(:permalink => "that_article"))
      get 'index', :path => ["that_page"]
      response.should be_success
      response.should render_template('pages/show')
    end
    
    it "should request an article by name" do
      Article.should_receive(:find_by_permalink).and_return(Article.new(:permalink => "that_article"))
      get 'index', :path => ["that_article"]
      response.should redirect_to permalink_url('that_article')
    end
    
  end
  
end