require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GreenHostingStoreController do

  #Delete these examples and add some real ones
  it "should use GreenHostingStoreController" do
    controller.should be_an_instance_of(GreenHostingStoreController)
  end


  describe "GET 'choose_domain'" do
    it "should be successful" do
      get 'choose_domain'
      response.should be_success
    end
  end

  describe "GET 'choose_package'" do
    it "should be successful" do
      get 'choose_package'
      response.should be_success
    end
  end

  describe "GET 'choose_addon'" do
    it "should be successful" do
      get 'choose_addon'
      response.should be_success
    end
  end

  describe "GET 'checkout'" do
    it "should be successful" do
      get 'checkout'
      response.should be_success
    end
  end

  describe "GET 'confirmation'" do
    it "should be successful" do
      get 'confirmation'
      response.should be_success
    end
  end
end
