class GreenHostingStoreController < ApplicationController
  include ActiveMerchant::Billing
  include CartSystem
  
  before_filter :login_required, :only => [  :billing, :payment, :confirmation]
  before_filter :require_account, :only => [ :billing, :payment, :confirmation]
  before_filter :load_cart
  before_filter :cart_not_empty, :only => [:checkout, :billing, :payment, :confirmation]

  
  def index
    redirect_to :action => "choose_domain"
  end
  
  def choose_package
    @package = Product.new
     # find all monthly sorted by price
    packages_monthly = Product.packages.enabled.find(:all, :conditions => {:recurring_month => 1}, :order => 'cost') 
    packages_yearly = Product.packages.enabled.find(:all, :conditions => {:recurring_month => 12}, :order => 'cost')
    # create a nested array of packages ordered by cost and grouped by package
    # for example [1,2,3].zip [4,5,6] => [[1, 4], [2, 5], [3, 6]]
    @packages = packages_monthly.zip packages_yearly
  end

  def choose_domain
    @domain = Domain.new
    
    
    # if this is a new package, we need to connect two cart items together?
    # if this is a new domain, we need to connect it to 
    
    @packages = Product.packages.enabled.find(:all, :order => 'cost')
    
    if params[:package_id]
      @product = Product.packages.enabled.find(params[:package_id])
      @cart_item = CartItem.new(:product => @product)
    elsif params[:id]
      @cart_item = CartItem.find(params[:id])
    end
    
    
  end

  def check_domain
    
    @domain = Domain.new(:name => params[:domain])
    @domain.name.gsub!('www.','')
    render :update do |page|
      if @domain.available?
        page.replace_html 'dialog', :partial => 'domain_available'
        page << "jQuery('#dialog').dialog( 'destroy' );"
        page << "jQuery('#dialog').dialog({ modal: true, draggable: false,resizeable: false, closeOnEscape: true, autoOpen: true, buttons: { 'Add To Cart': function(){ $.ajax({asyc:true, data:{domain: '#{@domain.name}', authenticity_token: '#{form_authenticity_token}'}, dataType: 'script', type:'post', url: '/cart/add_domain'})}, 'Cancel': function() { jQuery(this).dialog('close');} }});"
      else
        page.replace_html 'choose_domain_message' , "<span style='color: red'>Domain #{@domain.name} is not available</span>"
      end
    end
  #rescue => e
    # render :update do |page|
    #     page << 'allow_check_domain()'
    #     page.replace_html 'choose_domain_message' , "<span style='color: red'>Bad domain name</span>"
      # end
  end
  
  
  def add_hosting
    @package = Product.find(params[:id])
    @data = {}
    @hosting = Hosting.new(params[:hosting])
    render :update do |page|
      page.replace_html 'dialog', :partial => 'hosting_details'
    end
  end
  
  def edit_package
    @package = Product.find(params[:id])
    @hosting = Hosting.new(params[:hosting])
    @hosting.generate_password if @hosting.password.blank?
    @hosting.generate_username if @hosting.username.blank?
    @data = {}
  end


  def choose_addon
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
          begin
            @account = current_user.accounts.create(params[:account])
            session[:account] = @account
            redirect_to :action => :billing and return
          rescue
          end
        end
      end
    else
      store_location
      @user = User.new(params[:user])
      @account = Account.new(params[:account])
      if request.post?
        if @user.valid? and @account.valid?
          @user.save
          @user.accounts << @account
          @user.register_from_checkout!
          session[:user_id] = @user.id
          session[:account] = @account.id
          redirect_to :action => "billing"
        end
      end
    end
  end

  def billing
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
    @sidebar = ''
    @terms_of_service = Page.find_by_permalink('terms_of_service')
  end

  def payment
    @order = Order.from_cart(@cart)
    @order.account = @account
    if @order.save 
      redirect_to :action => 'thanks' and return if @account.charge_order(@order)
    end
    @sidebar = ''
    render :action => 'confirmation'
  end
  
  def thanks
    @sidebar = ''
  end
  
private
  
  def cart_not_empty
    if @cart.cart_items.empty?
      flash[:notice] = "Please choose a hosting package before checking out"
      redirect_to :action => 'choose_package' 
    end
  end
  
end
