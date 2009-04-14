class GreenHostingStoreController < ApplicationController

  before_filter :require_account, :only => [:checkout, :payment]

  #maybe these should be more along the lines of add_to_cart, remove_from_cart
  def choose_domain
  end

  def choose_package
  end

  def choose_addon
  end

  def checkout

    #TODO user must be signed in
    #TODO account must be selected or created
    #TODO get the cart from session?
    
    
  end

  def payment
    @order = Order.from_cart(@cart)
    @credit_card = CreditCard.new(params[:credit_card])
    
    #TODO create a Hosting for each Purchase of a HostingPlan
    #TODO create an AddOn for each Purchase of a ?
    
    #TODO create a Domain for each Purchase of a ?
    
    #TODO set up subscription for hosting
    
    #TODO -total charge for order?  total charge for Account?  subscriptions belong to ... Account?  Purchase?  Order?
    
    if @order.valid? && @credit_card.valid?
      response = @order.authorized?(@credit_card)
      if response.success?
        @account.save_credit_card(@credit_card)
        @order.make_payment(@credit_card,response.authorization)
        redirect_to :action => 'thanks' and return
      end
      flash[:error] = response.message
    end
    
  end

  def confirmation
  end
  
private

  def authorize_net_gateway
    AuthorizeNetGateway.new(
      if RAILS_ENV == 'production'
        { :login => 'prod',
          :password => 'pass'
        }
      else
        { :login => 'devel',
          :password => 'pass',
          :test => true
        }
      end)
  end
  
  def paypal_gateway
    PaypalExpressGateway.new(
      if RAILS_ENV == 'production'
        { :login => 'prod',
          :password => 'pass'
        }
      else
        { :login => 'devel',
          :password => 'pass',
          :test => true
        }
      end)
  end
  
  def purchase_tracking
    { :customer => "#{@account.first_name} #{@account.last_name}",
      :order_id => @order.invoice_number
    }
  end
end
