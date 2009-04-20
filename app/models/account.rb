class Account < ActiveRecord::Base
  #This is an organization level account that can have many users and hosting accounts
  #likewise an individual user can be associated with multiple accounts
  
  has_and_belongs_to_many :users
  
  has_many :hostings
  has_many :domains 

  attr_protected :balance
  
  has_many :payments
  has_one :payment_profile
  
  belongs_to :address
  belongs_to :billing_address, :class_name => "Address"
  
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :billing_address
  
  def store_card(creditcard, gw_options = {})
    # Clear out payment info if switching to CC from PayPal
    destroy_gateway_record(paypal) if paypal?
    
    gw_options = {
      :billing_address => billing_address.attributes.merge({:first_name => first_name, :last_name => last_name})
    }.merge(gw_options)
    
    @response = if billing_id.blank?
      gateway.store(creditcard, gw_options)
    else
      gateway.update(billing_id, creditcard, gw_options)
    end
    
    if @response.success?
      self.card_number = creditcard.display_number
      self.card_expiration = "%02d-%d" % [creditcard.expiry_date.month, creditcard.expiry_date.year]
      set_billing
    else
      errors.add_to_base(@response.message)
      false
    end
  end
  
  # Charge the card on file any amount you want.  Pass in a dollar
  # amount (1.00 to charge $1).  A SubscriptionPayment record will
  # be created, but the subscription itself is not modified.
  def charge(amount)
    if amount == 0 || (@response = gateway.purchase((amount.to_f * 100).to_i, billing_id)).success?
      payments.create(:account => account, :amount => amount, :transaction_id => @response.authorization)
      true
    else
      errors.add_to_base(@response.message)
      false
    end
  end
  
  

  def authorized?(order)
    gateway = authorize_net_gateway #self.paypal? ? paypal_gateway : authorize_net_gateway
    amount = order.total_charge_in_pennies
    response = gateway.authorize(amount, self.credit_card, {:address => '',:ip => '127.0.0.1'}.merge!(purchase_tracking(order)))    
  end
  
  def pay(order)
    amount = order.total_charge_in_pennies
    if (@response = gateway.purchase(amount, billing_id)).success?
      payments.create(:amount => amount, :transaction_id => @response.authorization, :order_id => order)
      order.paid!
      true
    else
      order.errors.add_to_base(@response.message)
      false
    end
  end
  
  def needs_payment_info?
    self.card_number.blank?
  end
  
  def start_paypal(return_url, cancel_url)
    if (@response = paypal.setup_authorization(:return_url => return_url, :cancel_return_url => cancel_url, :description => AppConfig['app_name'])).success?
      paypal.redirect_url_for(@response.params['token'])
    else
      errors.add_to_base("PayPal Error: #{@response.message}")
      false
    end
  end
  
  def complete_paypal(token)
    if (@response = paypal.details_for(token)).success?
      if (@response = paypal.create_billing_agreement_for(token)).success?
        # Clear out payment info if switching to PayPal from CC
        destroy_gateway_record(cc) unless paypal?

        self.card_number = 'PayPal'
        self.card_expiration = 'N/A'
        set_billing
      else
        errors.add_to_base("PayPal Error: #{@response.message}")
        false
      end
    else
      errors.add_to_base("PayPal Error: #{@response.message}")
      false
    end
  end
  
  def email
    self.users.empty? ? "" : self.users.first.email
  end
  
  def balance
    self['balance'] || 0
  end
  
protected
  
  def paypal?
    false
  end
  
  def gateway
    authorize_net_gateway
  end
  
  def profile
    throw "Billing profile cannot be created for unsaved account" if self.new_record?
    
    if(self.customer_profile_id.blank?)
      response = authorize_net_cim_gateway.create_customer_profile( :profile => {
        :merchant_customer_id => self.id,
        :email => self.email,
        :description => self.organization
      })
      self.update_attribute(:customer_profile_id,response.params['customer_profile_id']) if response.success?      
    end
    
    self.customer_profile_id
  end
  

  
  def destroy_gateway_record(gw = gateway)
    return if customer_profile_id.blank?
    gw.unstore(customer_profile_id)
    self.card_number = nil
    self.card_expiration = nil
    self.customer_profile_id = nil
  end
  
  def card_storage
    self.store_card(@creditcard, :billing_address => @address.to_activemerchant) if @creditcard && @address && card_number.blank?
  end
  

  def paypal_gateway
    ActiveMerchant::Billing::Base.gateway(:paypal_express_reference_nv).new(
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
  
  def authorize_net_gateway
    ActiveMerchant::Billing::Base.gateway(:authorize_net_cim).new(
    if RAILS_ENV == 'production'
      { :login => '2N3439BNayw56ndw',
        :password => 'smk510'
      }
    else
      { :login => '2N3439BNayw56ndw',
        :password => 'smk510',
        :test => true
      }
    end)
  end

  
  def purchase_tracking(order)
    { :customer => "#{self.first_name} #{self.last_name}",
      :order_id => order.invoice_number
    }
  end
  
end
