require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CertificateTicketsController do
  fixtures :users, :roles, :roles_users
  
  def mock_certificate_ticket(stubs={})
    @mock_certificate_ticket ||= mock_model(CertificateTicket, stubs)
  end
  
  describe "Anybody" do
  
    describe "responding to GET show" do

      it "should expose the requested certificate_ticket as @certificate_ticket" do
        CertificateTicket.should_receive(:find).with("37").and_return(mock_certificate_ticket)
        get :show, :id => "37"
        assigns[:certificate_ticket].should equal(mock_certificate_ticket)
      end
    
      describe "with mime type of xml" do

        it "should render the requested certificate_ticket as xml" do
          request.env["HTTP_ACCEPT"] = "application/xml"
          CertificateTicket.should_receive(:find).with("37").and_return(mock_certificate_ticket)
          mock_certificate_ticket.should_receive(:to_xml).and_return("generated XML")
          get :show, :id => "37"
          response.body.should == "generated XML"
        end

      end
    
    end

    describe "responding to GET new" do
  
      it "should expose a new certificate_ticket as @certificate_ticket" do
        CertificateTicket.should_receive(:new).and_return(mock_certificate_ticket)
        get :new
        assigns[:certificate_ticket].should equal(mock_certificate_ticket)
      end

    end


    describe "responding to POST create" do

      describe "with valid params" do
      
        it "should expose a newly created certificate_ticket as @certificate_ticket" do
          CertificateTicket.should_receive(:new).with({'these' => 'params'}).and_return(mock_certificate_ticket(:save => true))
          post :create, :certificate_ticket => {:these => 'params'}
          assigns(:certificate_ticket).should equal(mock_certificate_ticket)
        end

        it "should redirect to the created certificate_ticket" do
          CertificateTicket.stub!(:new).and_return(mock_certificate_ticket(:save => true))
          post :create
          response.should redirect_to(certificate_ticket_url(mock_certificate_ticket))
        end
      
      end
    
      describe "with invalid params" do

        it "should expose a newly created but unsaved certificate_ticket as @certificate_ticket" do
          CertificateTicket.stub!(:new).with({'these' => 'params'}).and_return(mock_certificate_ticket(:save => false))
          post :create, :certificate_ticket => {:these => 'params'}
          assigns(:certificate_ticket).should equal(mock_certificate_ticket)
        end

        it "should re-render the 'new' template" do
          CertificateTicket.stub!(:new).and_return(mock_certificate_ticket(:save => false))
          post :create, :certificate_ticket => {}
          response.should render_template('new')
        end
      
      end
    
    end

  end

  describe "When logged in " do
    before :each do
      login_as(:aaron)
    end
    
    describe "responding to GET edit" do

      it "should expose the requested certificate_ticket as @certificate_ticket" do
        CertificateTicket.should_receive(:find).with("37").and_return(mock_certificate_ticket)
        get :edit, :id => "37"
        assigns[:certificate_ticket].should equal(mock_certificate_ticket)
      end

    end
    
    describe "responding to PUT update" do

      describe "with valid params" do

        it "should update the requested certificate_ticket" do
          CertificateTicket.should_receive(:find).with("37").and_return(mock_certificate_ticket)
          mock_certificate_ticket.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :certificate_ticket => {:these => 'params'}
        end

        it "should expose the requested certificate_ticket as @certificate_ticket" do
          CertificateTicket.stub!(:find).and_return(mock_certificate_ticket(:update_attributes => true))
          put :update, :id => "1", :certificate_ticket => {}
          assigns(:certificate_ticket).should equal(mock_certificate_ticket)
        end

        it "should redirect to the certificate_ticket" do
          CertificateTicket.stub!(:find).and_return(mock_certificate_ticket(:update_attributes => true))
          put :update, :id => "1", :certificate_ticket => {}
          response.should redirect_to(certificate_ticket_url(mock_certificate_ticket))
        end

      end

      describe "with invalid params" do

        it "should update the requested certificate_ticket" do
          CertificateTicket.should_receive(:find).with("37").and_return(mock_certificate_ticket)
          mock_certificate_ticket.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :certificate_ticket => {:these => 'params'}
        end

        it "should expose the certificate_ticket as @certificate_ticket" do
          CertificateTicket.stub!(:find).and_return(mock_certificate_ticket(:update_attributes => false))
          put :update, :id => "1"
          assigns(:certificate_ticket).should equal(mock_certificate_ticket)
        end

        it "should re-render the 'edit' template" do
          CertificateTicket.stub!(:find).and_return(mock_certificate_ticket(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end

      end

    end
    

  end
  
  describe "Only the administrator" do
    
    before :each do
      login_as(:quentin)
    end
    
    
    describe "responding to GET index" do

      it "should expose all certificate_tickets as @certificate_tickets" do
        CertificateTicket.should_receive(:find).with(:all).and_return([mock_certificate_ticket])
        get :index
        assigns[:certificate_tickets].should == [mock_certificate_ticket]
      end

      describe "with mime type of xml" do

        it "should render all certificate_tickets as xml" do
          request.env["HTTP_ACCEPT"] = "application/xml"
          CertificateTicket.should_receive(:find).with(:all).and_return(certificate_tickets = mock("Array of CertificateTickets"))
          certificate_tickets.should_receive(:to_xml).and_return("generated XML")
          get :index
          response.body.should == "generated XML"
        end

      end

    end
    
    
    describe "responding to DELETE destroy" do

       it "should destroy the requested certificate_ticket" do
         CertificateTicket.should_receive(:find).with("37").and_return(mock_certificate_ticket)
         mock_certificate_ticket.should_receive(:destroy)
         delete :destroy, :id => "37"
       end

       it "should redirect to the certificate_tickets list" do
         CertificateTicket.stub!(:find).and_return(mock_certificate_ticket(:destroy => true))
         delete :destroy, :id => "1"
         response.should redirect_to(certificate_tickets_url)
       end
     end
  end

end