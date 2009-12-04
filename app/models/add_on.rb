class AddOn < ActiveRecord::Base
  include AASM
  
  belongs_to :product
  belongs_to :hosting
  belongs_to :account
  
  named_scope :due, :include => :product, :conditions => ['next_charge_on <= CURDATE() && products.recurring_month != 0']
  
  
  aasm_column :state
  aasm_initial_state :ordered
  aasm_state :ordered
  aasm_state :active
  aasm_state :complete
  aasm_state :suspended
  aasm_state :deleted
  
  aasm_event :activate do
    transitions :from => :ordered, :to => :active
  end
  
  aasm_event :suspend do
    transitions :from => [:ordered, :active], :to => :suspended
  end
  
  aasm_event :completed do
    transitions :from => [:ordered, :active], :to => :complete
  end
  
  aasm_event :delete do
    transitions :from => [:ordered, :active, :suspended], :to => :deleted
  end

  aasm_event :unsuspend do
    transitions :from => :suspended, :to => :active
  end
  
  
  include Chargeable
  before_create :initialize_next_charge, :unless => Proc.new { |a| a.attribute_present?("next_charge_on") }
  
end
