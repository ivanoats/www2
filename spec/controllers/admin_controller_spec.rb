require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdminController do
  before :each do
    @user = mock('User', {:has_role? => true})
    @controller.stubs(:current_user).returns(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index', {}, {:user_id => 1}
      response.should have_been_success
      response.should be_success
    end
  end
  
  describe 'POST provision' do
    
  end
end
