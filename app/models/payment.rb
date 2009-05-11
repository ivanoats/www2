class Payment < ActiveRecord::Base
  belongs_to :account
  belongs_to :order
  belongs_to :payable, :polymorphic => true
  
  
  def amount_in_cents
    (self.amount * 100).to_i
  end
  
  def description
    "Payment"
  end
end
