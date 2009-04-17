require File.dirname(__FILE__) + '/../spec_helper'
require 'pp'

describe TagsController do
  integrate_views
  fixtures :users, :roles, :roles_users

  before(:each) do
    @valid_attributes = {
      :name => "tag1",
      :description => "this is the tag description"
    }
  end
  
  def mock_tag(stubs={})
     @tag ||= mock_model(Tag, stubs)
   end
  
  describe "Anybody" do
    
    it "index should render index template" do
      get :index
      response.should render_template('index')
    end

    it "show should render show template" do
      @tag = Tag.create!(@valid_attributes)
      get :show, :id => @tag.name
      response.should render_template('show')
    end  
    
    it "should show tag cloud (index)" do
      pending("if it ain't broke")
    end
    
    it "should show tag with artilce list" do
      pending("if it ain't broke")
    end
    
    it "should show tag description" do
      @tag = Tag.create!(@valid_attributes)
      get :show, :id => @tag.name
      response.body.should include( "tag description" )
    end
  end
  
  describe "Administrator" do
    before :each do
      login_as(:quentin)
    end
    
    it "should be able to edit tag description" do
      pending("not implemented")
    end
  end
end