class Domain < ActiveRecord::Base
  include AASM
  include Chargeable
  before_create :initialize_next_charge, :unless => Proc.new { |a| a.attribute_present?("next_charge_on") }
  
  after_create :auto_activate_free_domains
  
  belongs_to :account
  belongs_to :product
  belongs_to :hosting
  
  manage_with_enom

  aasm_column :state
  aasm_initial_state :ordered
  aasm_state :ordered
  aasm_state :active, :enter => :purchase_if_necessary
  aasm_state :suspended
  aasm_state :deleted
  
  aasm_event :activate do
    transitions :from => :ordered, :to => :active
  end
  
  aasm_event :suspend do
    transitions :from => [:ordered, :active], :to => :suspended
  end
  
  aasm_event :delete do
    transitions :from => [:ordered, :active, :suspended], :to => :deleted
  end

  aasm_event :unsuspend do
    transitions :from => :suspended, :to => :active
  end

  def purchase_if_necessary
    purchase! if self.purchased
  end

  def purchase_with_attributes!
    options = {
      :NS1                        => 'ns1.example.com',
      :NS2                        => 'ns2.example.com',
      :NumYears                   => 1,
      :RegistrantOrganizationName => self.account.organization,
      :RegistrantAddress1         => self.account.billing_address.street,
      :RegistrantCity             => self.account.billing_address.city,
      :RegistrantPostalCode       => self.account.billing_address.zip,
      :RegistrantCountry          => self.account.billing_address.country,
      :RegistrantEmailAddress     => self.account.email,
      :RegistrantPhone            => self.account.phone,
    }
    purchase_without_attributes!(options)
  end
  alias_method_chain :purchase!, :attributes

protected

  def auto_activate_free_domains
    self.activate! unless self.purchased
  end

end
