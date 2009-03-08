require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ServersController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "servers", :action => "index").should == "/servers"
    end
  
    it "should map #new" do
      route_for(:controller => "servers", :action => "new").should == "/servers/new"
    end
  
    it "should map #show" do
      route_for(:controller => "servers", :action => "show", :id => 1).should == "/servers/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "servers", :action => "edit", :id => 1).should == "/servers/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "servers", :action => "update", :id => 1).should == "/servers/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "servers", :action => "destroy", :id => 1).should == "/servers/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/servers").should == {:controller => "servers", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/servers/new").should == {:controller => "servers", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/servers").should == {:controller => "servers", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/servers/1").should == {:controller => "servers", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/servers/1/edit").should == {:controller => "servers", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/servers/1").should == {:controller => "servers", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/servers/1").should == {:controller => "servers", :action => "destroy", :id => "1"}
    end
  end
end
