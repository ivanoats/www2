class GreenHostingStoreController < ApplicationController
  include ActiveMerchant::Billing
  include CartSystem
  
  before_filter :login_required, :only => [ :billing, :payment]
  before_filter :require_account, :only => [ :billing, :payment]

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
    load_cart
    
  end
  
  def billing
    @credit_card = CreditCard.new(params[:credit_card])
    if @credit_card.valid?
      @account.save_credit_card(@credit_card)
    end
  end
  
  def payment
    @order = Order.from_cart(@cart)
    if @order.valid? 
      response = @account.authorized?(@order)
      if response.success?
        @account.pay(@order, response.authorization)
        redirect_to :action => 'thanks' and return
      end
      flash[:error] = response.message
    end
    
  end

  def confirmation
  end

end
