require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountsController do

  before :each do
    @controller.stubs( :login_required )  #mock user is logged in
    @controller.stubs(:current_user).returns(mock_model(User, :has_role? => true ))
  end
  
  describe 'show' do
    it 'should get show' do
      @object = Account.new
      Account.expects(:find).returns(@object)
      get 'show', {:id => 1}
      
      response.should be_redirect
      response.should redirect_to(:controller => :account, :action => :manage)
    end
  end
  
  it_should_behave_like "model controller index"
  it_should_behave_like "model controller create"
  it_should_behave_like "model controller update"
  it_should_behave_like "model controller edit"
  it_should_behave_like "model controller destroy"

end
