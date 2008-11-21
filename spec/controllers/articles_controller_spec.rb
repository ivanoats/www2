require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArticlesController do
  
  describe "responding to GET index" do

    it "should expose all products as @products" do
      Article.should_receive(:find).with(:all).and_return([mock_product])
      get :index
      assigns[:products].should == [mock_product]
    end
  end

    describe "with mime type of xml" do
  
      it "should render all products as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Product.should_receive(:find).with(:all).and_return(products = mock("Array of Products"))
        products.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end
  
  
  
  
  
  
  
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "products", :action => "index").should == "/products"
    end
  
    it "should map #new" do
      route_for(:controller => "products", :action => "new").should == "/products/new"
    end
  
    it "should map #show" do
      route_for(:controller => "products", :action => "show", :id => 1).should == "/products/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "products", :action => "edit", :id => 1).should == "/products/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "products", :action => "update", :id => 1).should == "/products/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "products", :action => "destroy", :id => 1).should == "/products/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/products").should == {:controller => "products", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/products/new").should == {:controller => "products", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/products").should == {:controller => "products", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/products/1").should == {:controller => "products", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/products/1/edit").should == {:controller => "products", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/products/1").should == {:controller => "products", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/products/1").should == {:controller => "products", :action => "destroy", :id => "1"}
    end
  end
end
