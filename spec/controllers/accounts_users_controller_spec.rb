require ('spec_helper')
describe AccountsUsersController do

  before(:each) do
    @user = User.new()
    @user.stubs(:valid?).returns(true)
    @controller.stubs(:current_user).returns(@user)
  end
  
  it 'should add an existing user by email address' do
    @params = {:user => {:email => 'user@email.com'}, :account_id => 1}
    User.expects(:find_by_email).with('user@email.com').returns(User.new(:email => 'user@email.com'))
    #Account.expects(:find_)
    post :add_from_email, @params
    response.should render_template('account/_user')    
  end

  it 'should add a new user by email address' do
    @params = {:user => {:email => 'user@email.com'}, :account_id => 1}
    User.expects(:find_by_email).with('user@email.com').returns(nil)
    UserMailer.expects :deliver_admin_notification
    post :add_from_email, @params
    response.should render_template('account/_user')
  end

  
  it_should_behave_like "join model controller create"
  it_should_behave_like "join model controller destroy"
    
end
