require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdminController do

  #Delete these examples and add some real ones
  it "should use AdminController" do
    controller.should be_an_instance_of(AdminController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
  
  describe 'POST provision' do
    it 'should '
  end
end
