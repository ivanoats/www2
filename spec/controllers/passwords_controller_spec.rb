require 'spec_helper'

describe PasswordsController do

  it "should use PasswordsController" do
    controller.should be_an_instance_of(PasswordsController)
  end


  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'reset'" do
    it "should be successful for a valid code" do
      
      Password.expects(:find).returns(mock_model(Password, :user => mock_user))
      
      post 'reset', {:reset_code => 'reset code'}
      response.should be_success
    end
    
    it 'should redirect for an invalid code' do
      post 'reset', {:reset_code => 'invalid code'}
      response.should be_redirect
    end
  end
  
  describe 'create' do
    it 'should reset a valid email address' do
      User.expects(:find_by_email).with('blerg@example.com').returns(mock_user(:blank? => true, :destroyed => false))
      post 'create', {:password => {:email => 'blerg@example.com'}}
      response.should be_success
    end
    
    it 'should show a message if the email is invalid' do
      User.expects(:find_by_email).returns(nil)
      post 'create', {:password => {:email => 'invalid@example.com'}}
      flash[:error].should match('User not found')
      response.should be_success
    end
    
    it 'should show error messages if the password is invalid' do
     Password.expects(:new).returns(mock_model(Password,{:save => false, :email => 'blerg@example.com', :'user' => 'blerg@example.com', :'user=' => true}))
      User.expects(:find_by_email).with('blerg@example.com').returns(mock_user(:blank? => true, :destroyed => false))
      post 'create', {:password => {:email => 'blerg@example.com'}}
      response.should be_success
    end
  end
  
  describe 'update_after_forgetting' do
    it 'should update a password with a valid token' do
      Password.expects(:find_by_reset_code).with('ok').returns(mock_model(Password,{:user => mock_user( :update_attributes => true)}))
      
      post 'update_after_forgetting', {:reset_code => 'ok'}
      response.should be_redirect
      flash[:notice].should == 'Password was successfully updated.'
    end

    it 'should not explode on failure' do
      Password.expects(:find_by_reset_code).with('ok').returns(mock_model(Password,{:user => mock_user(:update_attributes => false)}))
      
      post 'update_after_forgetting', {:reset_code => 'ok'}
      response.should be_redirect
      flash[:notice].should == 'EPIC FAIL!'
      
    end
  end
  
  describe 'update' do
    it 'should update with valid attributes' do
      Password.expects(:find).with('1').returns(mock_model(Password,:update_attributes => true))
      
      post 'update', {:id => '1'}
      response.should be_redirect
      flash[:notice].should == 'Password was successfully updated.'
    end

    it 'should not explode on failure' do
      Password.expects(:find).with('1').returns(mock_model(Password,:update_attributes => false))
      
      post 'update', {:id => '1'}
      response.should be_success      
    end
  
  end
end
