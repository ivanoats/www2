require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "accounts", :action => "index").should == "/accounts"
    end
  
    it "maps #new" do
      route_for(:controller => "accounts", :action => "new").should == "/accounts/new"
    end
  
    it "maps #show" do
      route_for(:controller => "accounts", :action => "show", :id => "1").should == "/accounts/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "accounts", :action => "edit", :id => "1").should == "/accounts/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "accounts", :action => "create").should == {:path => "/accounts", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "accounts", :action => "update", :id => "1").should == {:path =>"/accounts/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "accounts", :action => "destroy", :id => "1").should == {:path =>"/accounts/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/accounts").should == {:controller => "accounts", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/accounts/new").should == {:controller => "accounts", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/accounts").should == {:controller => "accounts", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/accounts/1").should == {:controller => "accounts", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/accounts/1/edit").should == {:controller => "accounts", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/accounts/1").should == {:controller => "accounts", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/accounts/1").should == {:controller => "accounts", :action => "destroy", :id => "1"}
    end
  end
end
