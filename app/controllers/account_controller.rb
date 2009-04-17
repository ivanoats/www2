class AccountController < ApplicationController
  before_filter :login_required
  before_filter :require_account, :except => [:index, :new, :create]
  
  def index
   @accounts = Account.all

   respond_to do |format|
     format.html # index.html.erb
     format.xml  { render :xml => @redirects }
   end
 end
  
  def new
    @new_account = Account.new
  end
  
  def create
    @account = Account.new(params[:account])
    @account.users << current_user
    
    respond_to do |format|
      if @account.save
        session[:account] = @account.id
        flash[:notice] = 'Account was successfully created.'
        format.html { redirect_to({:action => :manage}) }
        format.xml  { render :xml => @account, :status => :created, :location => @account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  

  def manage
    
  end
  
  def edit
    
  end
  
  def update
    respond_to do |format|
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account was successfully updated.'
        format.html { redirect_to({:action => 'manage'}) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @redirect.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  def payments
    
  end
  
  def hosting
    
  end

private

  def require_account
    @account = Account.find_by_id(session[:account]) || current_user.accounts.first
    redirect_to root_url and flash[:error] = "An account is required to view this page" if @account.nil?
  end

end
