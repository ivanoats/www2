class CertificateTicketsController < ApplicationController
  
  require_role "Administrator", :only => [:index, :destroy]

  before_filter :login_required, :only => [:edit, :update]
  
  ssl_required :new, :create, :edit, :update
  
  
  def index
    @certificate_tickets = CertificateTicket.find :all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @certificate_tickets }
    end
  end

  def show
    @certificate_ticket = CertificateTicket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @certificate_ticket }
    end
  end

  def new
    @certificate_ticket = CertificateTicket.new(:country => 'US', :company_division => 'main')

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @certificate_ticket }
    end
  end

  def edit
    @certificate_ticket = CertificateTicket.find(params[:id])
  end

  def create
    @certificate_ticket = CertificateTicket.new(params[:certificate_ticket])

    respond_to do |format|
      if @certificate_ticket.save
        flash[:notice] = 'CertificateTicket was successfully created.'
        format.html { redirect_to(@certificate_ticket) }
        format.xml  { render :xml => @certificate_ticket, :status => :created, :location => @certificate_ticket }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @certificate_ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @certificate_ticket = CertificateTicket.find(params[:id])

    respond_to do |format|
      if @certificate_ticket.update_attributes(params[:certificate_ticket])
        flash[:notice] = 'CertificateTicket was successfully updated.'
        format.html { redirect_to(@certificate_ticket) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @certificate_ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @certificate_ticket = CertificateTicket.find(params[:id])
    @certificate_ticket.destroy

    respond_to do |format|
      format.html { redirect_to(admin_certificate_tickets_url) }
      format.xml  { head :ok }
    end
  end
end
