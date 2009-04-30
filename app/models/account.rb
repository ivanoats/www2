class Account < ActiveRecord::Base
  include AASM
  #This is an organization level account that can have many users and hosting accounts
  #likewise an individual user can be associated with multiple accounts
  
  has_and_belongs_to_many :users
  
  has_many :hostings
  has_many :domains 

  attr_protected :balance
  
  has_many :payments
  has_many :charges
  has_one :payment_profile
  
  belongs_to :address
  belongs_to :billing_address, :class_name => "Address"
  
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :billing_address
  
  named_scope :active, :conditions => ["state = ?",'active']
  named_scope :payment_due, :conditions => ['balance < ? and (last_payment_on IS NULL or last_payment_on < ?)',0,1.month.ago]
  
  aasm_column :state
  aasm_initial_state :active
  aasm_state :active
  aasm_state :suspended
  aasm_state :deleted

    
  aasm_event :suspend do
    transitions :from => [:ordered, :active], :to => :suspended
  end
  
  aasm_event :delete do
    transitions :from => [:ordered, :active, :suspended], :to => :deleted
  end

  aasm_event :unsuspend do
    transitions :from => :suspended, :to => :active
  end
  
  def transactions(params = {})
    transactions = (self.payments.find(:all,params.dup) + self.charges.find(:all,params))
    transactions.sort! { |a,b| a.created_at <=> b.created_at }
    transactions
  end
  
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
      self.billing_id = @response.token unless @response.token.blank?
      self.save
    else
      errors.add_to_base(@response.message)
      false
    end
  end
  
  # Charge the card on file any amount you want.  Pass in a dollar
  # amount (1.00 to charge $1).  
  def charge(amount)
    if amount == 0 || (@response = gateway.purchase((amount.to_f * 100).to_i, billing_id)).success?
      
      av = ActionView::Base.new(Rails::Configuration.new.view_path)
      receipt = av.render(
        :partial => "shared/payment_receipt", 
        :locals => {:amount => amount,
                    :previous_balance => self.balance,
                    :transactions => self.transactions({:conditions => ['created_at > ?',self.last_payment_on]}),
                    :new_balance => self.balance + amount})
      
      payments.create(:account => @account, :amount => amount, :transaction_id => @response.authorization, :receipt => receipt)
      true
    else
      errors.add_to_base(@response.message)
      false
    end
  end
  
  def charge_balance
    charge(balance)
  end
  
  def charge_order(order)
    amount = order.total_charge
    if (@response = gateway.purchase(amount)).success?
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
        self.billing_id = @response.token unless @response.token.blank?
        
      else
        errors.add_to_base("PayPal Error: #{@response.message}")
        false
      end
    else
      errors.add_to_base("PayPal Error: #{@response.message}")
      false
    end
  end
  

protected
  
  
  
  def paypal?
    false
  end
  
  def gateway
    authorize_net_gateway
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
      { :login => 'smk510',
        :password => '2N3439BNayw56ndw'
      }
    else
      { :login => 'smk510',
        :password => '2N3439BNayw56ndw',
        :test => true
      }
    end)
  end
  
end
