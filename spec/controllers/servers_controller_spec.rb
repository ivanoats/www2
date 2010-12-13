require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ServersController do

  def mock_server(stubs={})
    @mock_server ||= mock_model(Server, stubs)
  end
  
  before(:each) do 
    @user = mock('User', {:has_role? => true})
    @controller.stubs(:current_user).returns(@user)
  end
  

  
  it_should_behave_like "model controller index"
  it_should_behave_like "model controller create"
  it_should_behave_like "model controller update"
  it_should_behave_like "model controller show"
  it_should_behave_like "model controller edit"
  it_should_behave_like "model controller destroy"
  
  it 'should get hostings' do
    @server = Server.make
    Server.expects(:find).returns(@server)
    @whm = mock('Whm:Server',:accounts => [])    
    Whm::Server.expects(:new).returns(@whm)
    
    get 'hostings', :id => 1
    response.should have_been_success
    
  end
  
  it 'should get packages' do
    @server = Server.make
    Server.expects(:find).returns(@server)
    @whm = mock('Whm:Server',:packages => [])    
    Whm::Server.expects(:new).returns(@whm)
    get 'packages', :id => 1
    response.should have_been_success

  end
  
  it 'should put delete_unmanaged' do
    @server = Server.make
    Server.expects(:find).returns(@server)
    @account = mock('Whm:Account',:terminate! => nil)
    @whm = mock('Whm:Server',:account => @account)    
    Whm::Server.expects(:new).returns(@whm)
    
    put 'delete_unmanaged', :id => 1
    response.should have_been_redirect
    response.should redirect_to(:action => "hostings", :id => @server)  
  end

end
