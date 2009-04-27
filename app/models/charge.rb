class Charge < ActiveRecord::Base
  belongs_to :account
  belongs_to :chargable, :polymorphic => true
end
