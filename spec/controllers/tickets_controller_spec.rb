require File.dirname(__FILE__) + '/../spec_helper'

describe TicketsController do
  fixtures :users, :pages, :roles, :roles_users
  
  before :each do
    @ticket = Ticket.new
    Ticket.stub!(:find).with(:all).and_return [@ticket]
    Ticket.stub!(:find).and_return @ticket
  end
  
  describe "Anybody" do
    
    it "should show a ticket" do
      get :show, :id => 1
      response.should be_success
    end

    it "should show a new ticket" do
      get :new
      response.should be_success
    end
    
    it "should create a ticket" do
      ticket = Ticket.new
      Ticket.should_receive(:new).and_return ticket
      ticket.should_receive(:save).and_return true
      post :create, :id => 1
      response.should redirect_to(tickets_url)
    end
  end
  
  describe "When logged in " do
    before :each do
      login_as(:aaron)
    end
    
    it "should edit a ticket" do
      get :edit, :id => 1
      response.should be_success
    end

    it "should update a ticket" do
      @ticket.should_receive(:update_attributes).and_return true
      post :update, :id => 1
      response.should redirect_to(tickets_url)
    end
  end
  
  describe "Only the administrator" do
    
    before :each do
      login_as(:quentin)
    end
    
    it "should list tickets" do
      get 'index'
      response.should be_success
    end
    
    it "should destroy a ticket" do
      post :destroy, :id => 1
      response.should redirect_to(tickets_url)
    end
  end
end
