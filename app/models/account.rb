class Account < ActiveRecord::Base
  #This is an organization level account that can have many users and hosting accounts
  #likewise an individual user can be associated with multiple accounts
  
  has_and_belongs_to_many :users
  
  has_many :hostings
  has_many :domains 

  attr_protected :balance
  
  has_many :payments
  has_one :payment_profile

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
    create_or_update_cim_profile(options)
  end


  def authorized?(order)
    gateway = authorize_net_gateway #self.paypal? ? paypal_gateway : authorize_net_gateway
    amount = self.total_charge_in_pennies
    response = gateway.authorize(amount, self.credit_card_profile.customer_payment_profile_id, {:address => '',:ip => '127.0.0.1'}.merge!(purchase_tracking))
    
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
    return self.users.first.email unless self.users.empty?
    return ""
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

  def create_payment_profile(options = {})
    gateway = authorize_net_cim_gateway    
    response = gateway.create_customer_payment_profile({ :customer_profile_id => self.profile, :payment_profile => options})
    
    self.credit_card_profile.update_attribute(:customer_payment_profile_id,response.params['customer_payment_profile_id']) if response.success?
  end
  
  def update_payment_profile(options = {})
    gateway = authorize_net_cim_gateway
    options[:customer_payment_profile_id] = self.customer_payment_profile_id
    gateway.update_customer_payment_profile( :customer_profile_id => self.profile, :payment_profile => options, :customer_payment_profile_id => self.credit_card_profile.customer_payment_profile_id )
  end
  
  def create_or_update_cim_profile(options = {})
    if !self.cim_payment_profile_id
      self.create_cim_profile options
    else
      self.update_cim_profile options
    end
  end
  
  def authorize_net_gateway
    AuthorizeNetGateway.new(
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
  
  def authorize_net_cim_gateway
    ActiveMerchant::Billing::AuthorizeNetCimGateWay.new(:login => "", :password => "", :test => true)
  end
end
