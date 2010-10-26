require File.dirname(__FILE__) + '/../spec_helper'

describe TicketsController do
  fixtures :users, :pages, :roles, :roles_users
  
  def mock_ticket(stubs={})
    @mock_ticket ||= mock_model(Ticket, stubs)
  end
  
  before :each do
    @ticket = Ticket.new
    Ticket.stubs(:find).with(:all).returns [@ticket]
    Ticket.stubs(:find).returns @ticket
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
      @ticket = mock_ticket(:save => true)
      Ticket.expects(:new).returns @ticket
      post :create, :id => 1
      response.should redirect_to(ticket_url(@ticket))
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
      @ticket = mock_ticket(:update_attributes => true)
      Ticket.expects(:find).returns @ticket
      post :update, :id => 1
      response.should have_been_redirect
      response.should redirect_to(ticket_url(@ticket))
    end
  end
  
  describe "Only the administrator" do
    
    before :each do
      login_as(:quentin)
    end
    
    it "should list tickets" do
      Ticket.stubs(:find).returns [@ticket]
      
      get 'index'
      response.should be_success
    end
    
    it "should destroy a ticket" do
      post :destroy, :id => 1
      response.should redirect_to(tickets_url)
    end
  end
end
