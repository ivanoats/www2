require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HostingsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "hostings", :action => "index").should == "/hostings"
    end
  
    it "maps #new" do
      route_for(:controller => "hostings", :action => "new").should == "/hostings/new"
    end
  
    it "maps #show" do
      route_for(:controller => "hostings", :action => "show", :id => "1").should == "/hostings/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "hostings", :action => "edit", :id => "1").should == "/hostings/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "hostings", :action => "create").should == {:path => "/hostings", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "hostings", :action => "update", :id => "1").should == {:path =>"/hostings/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "hostings", :action => "destroy", :id => "1").should == {:path =>"/hostings/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/hostings").should == {:controller => "hostings", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/hostings/new").should == {:controller => "hostings", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/hostings").should == {:controller => "hostings", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/hostings/1").should == {:controller => "hostings", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/hostings/1/edit").should == {:controller => "hostings", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/hostings/1").should == {:controller => "hostings", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/hostings/1").should == {:controller => "hostings", :action => "destroy", :id => "1"}
    end
  end
end
