require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AccountController do

  #Delete these examples and add some real ones
  it "should use AccountController" do
    controller.should be_an_instance_of(AccountController)
  end


  describe "GET 'manage'" do
    it "should be successful" do
      get 'manage'
      response.should be_success
    end
  end
end
