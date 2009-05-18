require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RedirectsController do
  fixtures        :users

  def mock_redirect(stubs={})
    @mock_redirect ||= mock_model(Redirect, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all redirects as @redirects" do
      login_as :quentin      
      Redirect.expects(:find).with(:all).returns([mock_redirect])
      get :index
      assigns[:redirects].should == [mock_redirect]
    end
  end

  describe "responding to GET show" do

    it "should expose the requested redirect as @redirect" do
      login_as :quentin
      Redirect.expects(:find).with("37").returns(mock_redirect)
      get :show, :id => "37"
      assigns[:redirect].should equal(mock_redirect)
    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new redirect as @redirect" do
      login_as :quentin      
      Redirect.expects(:new).returns(mock_redirect)
      get :new
      assigns[:redirect].should equal(mock_redirect)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested redirect as @redirect" do
      login_as :quentin      
      Redirect.expects(:find).with("37").returns(mock_redirect)
      get :edit, :id => "37"
      assigns[:redirect].should equal(mock_redirect)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created redirect as @redirect" do
        login_as :quentin        
        Redirect.expects(:new).with({'these' => 'params'}).returns(mock_redirect(:save => true))
        post :create, :redirect => {:these => 'params'}
        assigns(:redirect).should equal(mock_redirect)
      end

      it "should redirect to the created redirect" do
        login_as :quentin        
        Redirect.stubs(:new).returns(mock_redirect(:save => true))
        post :create, :redirect => {}
        response.should redirect_to(redirect_path(mock_redirect))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved redirect as @redirect" do
        login_as :quentin        
        Redirect.stubs(:new).with({'these' => 'params'}).returns(mock_redirect(:save => false))
        post :create, :redirect => {:these => 'params'}
        assigns(:redirect).should equal(mock_redirect)
      end

      it "should re-render the 'new' template" do
        login_as :quentin        
        Redirect.stubs(:new).returns(mock_redirect(:save => false))
        post :create, :redirect => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested redirect" do
        login_as :quentin        
        Redirect.expects(:find).with("37").returns(mock_redirect)
        mock_redirect.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :redirect => {:these => 'params'}
      end

      it "should expose the requested redirect as @redirect" do
        login_as :quentin        
        Redirect.stubs(:find).returns(mock_redirect(:update_attributes => true))
        put :update, :id => "1"
        assigns(:redirect).should equal(mock_redirect)
      end

      it "should redirect to the redirect" do
        login_as :quentin
        Redirect.stubs(:find).returns(mock_redirect(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(redirect_path(mock_redirect))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested redirect" do
        login_as :quentin
        Redirect.expects(:find).with("37").returns(mock_redirect)
        mock_redirect.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :redirect => {:these => 'params'}
      end

      it "should expose the redirect as @redirect" do
        login_as :quentin        
        Redirect.stubs(:find).returns(mock_redirect(:update_attributes => false))
        put :update, :id => "1"
        assigns(:redirect).should equal(mock_redirect)
      end

      it "should re-render the 'edit' template" do
        login_as :quentin        
        Redirect.stubs(:find).returns(mock_redirect(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested redirect" do
      login_as :quentin
      Redirect.expects(:find).with("37").returns(mock_redirect)
      mock_redirect.expects(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the redirects list" do
      login_as :quentin
      Redirect.stubs(:find).returns(mock_redirect(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(redirects_url)
    end

  end

end
