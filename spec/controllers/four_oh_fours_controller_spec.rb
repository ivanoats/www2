require File.dirname(__FILE__) + '/../spec_helper'

describe FourOhFoursController do
  
  it "should route unknown urls here" do
    expected = { :controller => "four_oh_fours", :action => "index", :path=>["magic_article"] }
    params_from(:get, "/magic_article").should == expected
  end
  
  describe "with Redirects" do
    it "should find by slug and redirect permanently" do
      methods  = { :slug => "test-slug", :url => "http://test-url.com" }
      expected = mock_model(Redirect, methods)
      slug     = 'test-slug'
      
      Redirect.expects(:find_by_slug).with(slug).returns(expected)
      get 'index', :path => [slug]
      response.should redirect_to(expected.url)
      response.status.should include('301')
    end
  end
  
  describe "Anybody" do

    it "should spell something wrong" do
      get 'index', :path => ["magic_article"]
      response.should redirect_to(articles_path(:search => 'magic_article'))
    end
    
    it "should request a page by name" do
      page = mock_model(Page)
      Page.expects(:find_by_permalink).returns(Page.new(:permalink => "that_article"))
      get 'index', :path => ["that_page"]
      response.should be_success
      response.should render_template('pages/_show')
    end
    
    it "should request an article by name" do
      Article.expects(:find_by_permalink).returns(Article.new(:permalink => "that_article"))
      get 'index', :path => ["that_article"]
      response.should redirect_to(permalink_url('that_article'))
    end
    
    it "should request a page that does not exist and return the search page" do
      dummy_link = 'skdfjlskdfjlsdkfj'
      get 'index', :path => dummy_link
      response.should redirect_to(articles_path(:search => dummy_link))
      # response.body.should include('no results')
    end
    
    it "should request pages instead of page" #http://site.com/pages/asdkjalkdfj
    
  end
  
end