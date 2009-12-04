class Charge < ActiveRecord::Base
  belongs_to :account
  belongs_to :chargable, :polymorphic => true
  
  def description
    "#{self.chargable.name if self.chargable}"
  end

end
