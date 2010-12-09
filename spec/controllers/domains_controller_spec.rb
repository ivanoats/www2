require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DomainsController do
  
  before :each do
    @controller.stubs( :login_required )  #mock user is logged in
    @user = User.new
    @account = Account.new
    @user.stubs(:accounts).returns @account
    @controller.stubs(:current_user).returns(@user)
    Account.stubs(:find).returns(@account)
  end
  
  it_should_behave_like "model controller index"
  it_should_behave_like "model controller create"
  it_should_behave_like "model controller update"
  it_should_behave_like "model controller show"
  it_should_behave_like "model controller edit"
  it_should_behave_like "model controller destroy"

end