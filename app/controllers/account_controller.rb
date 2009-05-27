class AccountController < ApplicationController
  include ActiveMerchant::Billing
  
  before_filter :login_required
  before_filter :require_account, :except => [:new, :create, :switch_account]
  before_filter :require_payment_information, :only => :pay
  
  def index
    redirect_to :action => :manage
  end
  
  def new
    @new_account = Account.new
  end
  
  def create
    @account = Account.new(params[:account])
    
    
    respond_to do |format|
      if @account.save
        @account.users << current_user
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
    @history = @account.transactions
  end
  
  def order
    @order = @account.orders.find(params[:id])
  end
  
  def pay
    if request.post?
      amount = params[:amount].to_i
      @account.charge(amount)
      if @account.save
        flash[:notice] = "Payment completed"
        redirect_to :action => 'payments'
      end
    end
  end
  
  def hosting
  end
  
  def billing
    @address = @account.billing_address || @account.build_billing_address
    @credit_card = CreditCard.new(params[:credit_card])
    
    if request.post?
      
      if params[:paypal].blank?
        if @account.update_attributes(params[:account]) && @address.update_attributes(params[:address]) && @credit_card.valid?          
          if @account.store_card(@credit_card, :ip => request.remote_ip)
            flash[:notice] = "Your billing information has been updated."
            redirect_to :action => "billing"
          else
            flash[:notice] = "Failed to store credit card."
          end
        end
      else
        if redirect_url = @subscription.start_paypal(paypal_account_url, billing_account_url)
          redirect_to redirect_url
        end
      end
    end
  end
  
  def switch_account
    session[:account] = params[:id] if current_user.has_role?('Administrator') || current_user.accounts.include?( Account.find_by_id(params[:id]))
    render :update do |page|
      page.redirect_to :action => :manage
    end
  end
  
private

  def require_account
    @account = Account.find_by_id(session[:account]) || current_user.accounts.first
    redirect_to root_url and flash[:error] = "An account is required to view this page" if @account.nil?
  end
  
  def require_payment_information
    redirect_to :action => "billing" and flash[:error] = "Billing Information required" if @account.needs_payment_info?
  end
end
