class GreenHostingStoreController < ApplicationController
  include ActiveMerchant::Billing
  include CartSystem
  
  before_filter :require_account, :only => [:checkout, :payment]

  def choose_domain
    @domain = Domain.new
    load_cart
  end

  def choose_package
    load_cart
    @packages = Product.packages
  end

  def choose_addon
  end

  def checkout
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
