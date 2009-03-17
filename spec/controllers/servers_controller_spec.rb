require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "an admin user is signed in", :shared => true do
  before( :each ) do
     controller.stub!( :login_required )  #mock user is logged in
     controller.current_user = mock_model(User, :has_role? => true )  #mock user is admin 
   end
end

describe ServersController do

  def mock_server(stubs={})
    @mock_server ||= mock_model(Server, stubs)
  end
  
  
  describe "responding to GET index" do
    
    it_should_behave_like "an admin user is signed in"

    it "should expose all servers as @servers" do
      Server.should_receive(:find).with(:all).and_return([mock_server])
      get :index
      assigns[:servers].should == [mock_server]
    end

    describe "with mime type of xml" do
  
      it "should render all servers as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Server.should_receive(:find).with(:all).and_return(servers = mock("Array of Servers"))
        servers.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do
    it_should_behave_like "an admin user is signed in"

    it "should expose the requested server as @server" do
      Server.should_receive(:find).with("37").and_return(mock_server)
      get :show, :id => "37"
      assigns[:server].should equal(mock_server)
    end
    
    describe "with mime type of xml" do

      it "should render the requested server as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Server.should_receive(:find).with("37").and_return(mock_server)
        mock_server.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
    it_should_behave_like "an admin user is signed in"
  
    it "should expose a new server as @server" do
      Server.should_receive(:new).and_return(mock_server)
      get :new
      assigns[:server].should equal(mock_server)
    end

  end

  describe "responding to GET edit" do
    it_should_behave_like "an admin user is signed in"
  
    it "should expose the requested server as @server" do
      Server.should_receive(:find).with("37").and_return(mock_server)
      get :edit, :id => "37"
      assigns[:server].should equal(mock_server)
    end

  end

  describe "responding to POST create" do
    it_should_behave_like "an admin user is signed in"

    describe "with valid params" do
      
      it "should expose a newly created server as @server" do
        Server.should_receive(:new).with({'these' => 'params'}).and_return(mock_server(:save => true))
        post :create, :server => {:these => 'params'}
        assigns(:server).should equal(mock_server)
      end

      it "should redirect to the created server" do
        Server.stub!(:new).and_return(mock_server(:save => true))
        post :create, :server => {}
        response.should redirect_to(server_url(mock_server))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved server as @server" do
        Server.stub!(:new).with({'these' => 'params'}).and_return(mock_server(:save => false))
        post :create, :server => {:these => 'params'}
        assigns(:server).should equal(mock_server)
      end

      it "should re-render the 'new' template" do
        Server.stub!(:new).and_return(mock_server(:save => false))
        post :create, :server => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do
    it_should_behave_like "an admin user is signed in"

    describe "with valid params" do

      it "should update the requested server" do
        Server.should_receive(:find).with("37").and_return(mock_server)
        mock_server.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :server => {:these => 'params'}
      end

      it "should expose the requested server as @server" do
        Server.stub!(:find).and_return(mock_server(:update_attributes => true))
        put :update, :id => "1"
        assigns(:server).should equal(mock_server)
      end

      it "should redirect to the server" do
        Server.stub!(:find).and_return(mock_server(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(server_url(mock_server))
      end

    end
    
    describe "with invalid params" do
      it_should_behave_like "an admin user is signed in"

      it "should update the requested server" do
        Server.should_receive(:find).with("37").and_return(mock_server)
        mock_server.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :server => {:these => 'params'}
      end

      it "should expose the server as @server" do
        Server.stub!(:find).and_return(mock_server(:update_attributes => false))
        put :update, :id => "1"
        assigns(:server).should equal(mock_server)
      end

      it "should re-render the 'edit' template" do
        Server.stub!(:find).and_return(mock_server(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
    it_should_behave_like "an admin user is signed in"

    it "should destroy the requested server" do
      Server.should_receive(:find).with("37").and_return(mock_server)
      mock_server.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the servers list" do
      Server.stub!(:find).and_return(mock_server(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(servers_url)
    end

  end

end
