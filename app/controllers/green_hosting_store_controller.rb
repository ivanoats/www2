class GreenHostingStoreController < ApplicationController
  include ActiveMerchant::Billing
  include CartSystem
  
  before_filter :login_required, :only => [  :billing, :payment, :confirmation]
  before_filter :require_account, :only => [ :billing, :payment, :confirmation]
  before_filter :load_cart
  def choose_domain
    @domain = Domain.new
    load_cart
  end
  
  def check_domain
    @domain = Domain.new(params[:domain])
    render :update do |page|
      if @domain.available?
        page << 'allow_purchase_domain()'
        page.replace_html 'choose_domain_message' , "<span style='color: green'>Domain #{@domain.name} is available</span>"
      else
        page << 'allow_check_domain()'
        page.replace_html 'choose_domain_message' , "<span style='color: red'>Domain #{@domain.name} is not available</span>"
      end
    end
  end

  def choose_package
    load_cart
    @package = Product.new
     # find all monthly sorted by price
    packages_monthly = Product.find(:all, :conditions => {:recurring_month => 1,:kind => 'package'}, :order => 'cost') 
    packages_yearly = Product.find(:all, :conditions => {:recurring_month => 12,:kind => 'package'}, :order => 'cost')
    # create a nested array of packages ordered by cost and grouped by package
    # for example [1,2,3].zip [4,5,6] => [[1, 4], [2, 5], [3, 6]]
    @packages = packages_monthly.zip packages_yearly
     
  end
   

  def choose_addon
    load_cart
    @addon = Product.new
    @addons = Product.addons
  end


  def checkout
    
    if logged_in?
      if request.post?
        if params[:use_existing_account] == "true"
          #use existing account
          account = current_user.accounts.find(params[:account][:id])
          session[:account] = account.id
          redirect_to( account.needs_payment_info? ? {:action => :billing} : {:action => :confirmation}) and return
        else
          #create a new account
          account = current_user.accounts.create!(params[:account])
          session[:account] = account
          redirect_to :action => :billing and return
        end
      end
    else
      @user = User.new
      if request.post?
        
      end
    end
  end

  def billing
    load_cart
    @address = @account.billing_address || @account.build_billing_address
    @credit_card = CreditCard.new(params[:credit_card])

    
    if request.post?
      if params[:use_existing_credit_card]
        redirect_to :action => "confirmation"
      else
        if @account.update_attributes(params[:account]) && @address.update_attributes(params[:address]) && @credit_card.valid?          
          if @account.store_card(@credit_card, :ip => request.remote_ip)
            flash[:notice] = "Please Confirm your order"
            redirect_to :action => "confirmation"
          else
            flash[:notice] = "Failed to store credit card."
          end
        end
      end
    end
  end

  def confirmation
    
    
  end

  def payment
    load_cart
    @order = Order.from_cart(@cart)
    if @order.valid? 
      redirect_to :action => 'thanks' and return if @account.charge_order(@order)
    end
    render :action => 'confirmation'
  end

end
