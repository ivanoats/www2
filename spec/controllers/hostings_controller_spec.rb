require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HostingsController do

  def mock_hosting(stubs={})
    @mock_hosting ||= mock_model(Hosting, stubs)
  end
  
  describe "GET index" do
    it "assigns all hostings as @hostings" do
      Hosting.should_receive(:find).with(:all).and_return([mock_hosting])
      get :index
      assigns[:hostings].should == [mock_hosting]
    end
  end

  describe "GET show" do
    it "assigns the requested hosting as @hosting" do
      Hosting.should_receive(:find).with("37").and_return(mock_hosting)
      get :show, :id => "37"
      assigns[:hosting].should equal(mock_hosting)
    end
  end

  describe "GET new" do
    it "assigns a new hosting as @hosting" do
      Hosting.should_receive(:new).and_return(mock_hosting)
      get :new
      assigns[:hosting].should equal(mock_hosting)
    end
  end

  describe "GET edit" do
    it "assigns the requested hosting as @hosting" do
      Hosting.should_receive(:find).with("37").and_return(mock_hosting)
      get :edit, :id => "37"
      assigns[:hosting].should equal(mock_hosting)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created hosting as @hosting" do
        Hosting.should_receive(:new).with({'these' => 'params'}).and_return(mock_hosting(:save => true))
        post :create, :hosting => {:these => 'params'}
        assigns[:hosting].should equal(mock_hosting)
      end

      it "redirects to the created hosting" do
        Hosting.stub!(:new).and_return(mock_hosting(:save => true))
        post :create, :hosting => {}
        response.should redirect_to(hosting_url(mock_hosting))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved hosting as @hosting" do
        Hosting.stub!(:new).with({'these' => 'params'}).and_return(mock_hosting(:save => false))
        post :create, :hosting => {:these => 'params'}
        assigns[:hosting].should equal(mock_hosting)
      end

      it "re-renders the 'new' template" do
        Hosting.stub!(:new).and_return(mock_hosting(:save => false))
        post :create, :hosting => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT udpate" do
    
    describe "with valid params" do
      it "updates the requested hosting" do
        Hosting.should_receive(:find).with("37").and_return(mock_hosting)
        mock_hosting.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :hosting => {:these => 'params'}
      end

      it "assigns the requested hosting as @hosting" do
        Hosting.stub!(:find).and_return(mock_hosting(:update_attributes => true))
        put :update, :id => "1"
        assigns[:hosting].should equal(mock_hosting)
      end

      it "redirects to the hosting" do
        Hosting.stub!(:find).and_return(mock_hosting(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(hosting_url(mock_hosting))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested hosting" do
        Hosting.should_receive(:find).with("37").and_return(mock_hosting)
        mock_hosting.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :hosting => {:these => 'params'}
      end

      it "assigns the hosting as @hosting" do
        Hosting.stub!(:find).and_return(mock_hosting(:update_attributes => false))
        put :update, :id => "1"
        assigns[:hosting].should equal(mock_hosting)
      end

      it "re-renders the 'edit' template" do
        Hosting.stub!(:find).and_return(mock_hosting(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested hosting" do
      Hosting.should_receive(:find).with("37").and_return(mock_hosting)
      mock_hosting.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the hostings list" do
      Hosting.stub!(:find).and_return(mock_hosting(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(hostings_url)
    end
  end

end
