require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do
  
  describe "responding to GET index" do

    it "should list articles" do
      get :index
      response.should be_success
    end
    
    it "should list articles by category" do
      get :index, :category_id => 2
      response.should be_success
    end
    
    it "should search articles" do
      get :index, :search => "laser cats"
      response.should be_success
    end
    
    it "should render all products as xml" do
      request.env["HTTP_ACCEPT"] = "application/xml"
      #Article.should_receive(:find).and_return([mock("Array of Articles").should_receive(:to_xml).and_return("generated XML")])
      get :index
      #response.body.should == "generated XML"
    end
    
  end
end
