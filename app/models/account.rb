class Account < ActiveRecord::Base
  #This is an organization level account that can have many users and hosting accounts
  #likewise an individual user can be associated with multiple accounts
  
  has_and_belongs_to_many :users
  
  has_many :hostings
  has_many :domains 

  attr_protected :balance
  
  has_many :payments
  has_one :payment_profile
  
  def store_card(creditcard, gw_options = {})
    # Clear out payment info if switching to CC from PayPal
    destroy_gateway_record(paypal) if paypal?
    
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
      payments.create(:account => account, :amount => amount, :transaction_id => @response.authorization, :misc => true)
      true
    else
      errors.add_to_base(@response.message)
      false
    end
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
  
  
  def save_credit_card(credit_card)
    options = {}
    options[:payment] = {:credit_card => credit_card}
    options[:bill_to] = {
      :first_name => self.first_name,
      :last_name => self.last_name,
      :company => self.organization,
      :address => self.address,
      :city => self.city,
      :state => self.state,
      :zip => '',
      :country => self.country
    }
    update_credit_card_profile(options)
  end

  def credit_card
    return nil if self.credit_card_profile.customer_payment_profile_id.blank?
    authorize_net_cim_gateway.get_customer_payment_profile({:customer_profile_id => self.customer_profile_id, :customer_payment_profile_id => self.credit_card_profile.customer_payment_profile_id})
  end

  def authorized?(order)
    gateway = authorize_net_gateway #self.paypal? ? paypal_gateway : authorize_net_gateway
    amount = order.total_charge_in_pennies
    response = gateway.authorize(amount, self.credit_card, {:address => '',:ip => '127.0.0.1'}.merge!(purchase_tracking(order)))    
  end
  
  def pay(order, authorization)
    throw "Cannot pay order with bad authorization" unless response.success?
    gateway = authorize_net_gateway
    gateway.capture(amount, reponse.authorization)
    order.paid!
  end
  
  def address
    "#{self.address_1}\n #{self.address_2}"
  end
  
  def email
    self.users.empty? ? "" : self.users.first.email
  end
  
  def balance
    self['balance'] || 0
  end
  
protected
  
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
  
  def credit_card_profile
    self.payment_profile || PaymentProfile.create(:account => self)
  end

  def update_credit_card_profile(options = {})
    gateway = authorize_net_cim_gateway    
    if !self.credit_card_profile.customer_payment_profile_id
      response = gateway.create_customer_payment_profile({ :customer_profile_id => self.profile, :payment_profile => options})     
      self.credit_card_profile.update_attribute(:customer_payment_profile_id,response.params['customer_payment_profile_id']) if response.success?
    else
      options[:customer_payment_profile_id] = self.customer_payment_profile_id
      gateway.update_customer_payment_profile( :customer_profile_id => self.profile, :payment_profile => options, :customer_payment_profile_id => self.credit_card_profile.customer_payment_profile_id )
    end
  end
  
  def authorize_net_gateway
    ActiveMerchant::Billing::AuthorizeNetGateway.new(
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
  
  def paypal_gateway
    ActiveMerchant::Billing::PaypalExpressGateway.new(
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
  
  def authorize_net_cim_gateway
    ActiveMerchant::Billing::AuthorizeNetCimGateway.new(:login => "2N3439BNayw56ndw", :password => "smk510", :test => true)
  end
  
  
  def purchase_tracking(order)
    { :customer => "#{self.first_name} #{self.last_name}",
      :order_id => order.invoice_number
    }
  end
  
end
