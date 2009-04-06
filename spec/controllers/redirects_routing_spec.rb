require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RedirectsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "redirects", :action => "index").should == "/redirects"
    end
  
    it "should map #new" do
      route_for(:controller => "redirects", :action => "new").should == "/redirects/new"
    end
  
    it "should map #show" do
      route_for(:controller => "redirects", :action => "show", :id => '1').should == "/redirects/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "redirects", :action => "edit", :id => '1').should == "/redirects/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "redirects", :action => "update", :id => '1').should == { :path => "/redirects/1", :method => :put }
    end
  
    it "should map #destroy" do
      route_for(:controller => "redirects", :action => "destroy", :id => '1').should == { :path => "/redirects/1", :method => :delete }
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/redirects").should == {:controller => "redirects", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/redirects/new").should == {:controller => "redirects", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/redirects").should == {:controller => "redirects", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/redirects/1").should == {:controller => "redirects", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/redirects/1/edit").should == {:controller => "redirects", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/redirects/1").should == {:controller => "redirects", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/redirects/1").should == {:controller => "redirects", :action => "destroy", :id => "1"}
    end
  end
end
