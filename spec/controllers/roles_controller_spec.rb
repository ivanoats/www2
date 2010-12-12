require File.dirname(__FILE__) + '/../spec_helper'

describe RolesController do
  
  before :each do
    @user = mock('User', {:has_role? => true})
    @controller.stubs(:current_user).returns(@user)
  end
  
  it 'should get index' do
    User.expects(:find)
    Role.expects(:find)
    get 'index', {:user_id => 1}
    response.should be_success
    response.should render_template('index')
  end
  
  it 'should put update' do
    @user = User.make
    @user.expects(:has_role?).returns(false)
    User.expects(:find).returns(@user)
    
    @role = Role.make
    Role.expects(:find).returns(@role)
    put 'update', {:user_id => 1, :id => 1}
    response.should be_redirect
    response.should redirect_to(:action => 'index')
  end
  
  it 'should put destroy' do
    @user = User.make
    @user.expects(:has_role?).returns(true)
    User.expects(:find).returns(@user)
    @role = Role.make()
    Role.expects(:find).returns(@role)

    put 'destroy', {:user_id => 1, :id => 1}
    response.should be_redirect
    response.should redirect_to(:action => 'index')
    flash[:error].should == nil
  end


  it 'should put destroy the last administrator' do
    @user = User.make
    User.expects(:find).returns(@user)
    
    @role = Role.make(:name => 'Administrator')
    @role.expects(:users).returns [@user]
    Role.expects(:find).returns(@role)

    put 'destroy', {:user_id => 1, :id => 1}
    response.should be_redirect
    response.should redirect_to(:action => 'index')
    flash[:error].should include_text('delete the last one')
  end
  
end
# 
# def destroy 
#   @user = User.find(params[:user_id]) 
#   @role = Role.find(params[:id]) 
#   if @role == Role.administrator && @role.users.count == 1
#     raise ("cannot delete all administrators, you are trying to delete the last one")
#   end
#   if @user.has_role?(@role.name) 
#     @user.roles.delete(@role) 
#   end 
#   redirect_to :action => 'index' 
# end
