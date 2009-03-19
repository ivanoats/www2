require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SubscriptionController do

  #Delete these examples and add some real ones
  it "should use SubscriptionController" do
    controller.should be_an_instance_of(SubscriptionController)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'subscribe'" do
    it "should be successful" do
      get 'subscribe'
      response.should be_success
    end
  end

  describe "GET 'unsubscribe'" do
    it "should be successful" do
      get 'unsubscribe'
      response.should be_success
    end
  end

  describe "GET 'update_card'" do
    it "should be successful" do
      get 'update_card'
      response.should be_success
    end
  end

  describe "GET 'invoice'" do
    it "should be successful" do
      get 'invoice'
      response.should be_success
    end
  end
end
