class Purchase < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :purchasable, :polymorphic => true
  def redeem
    case product.kind
    when 'package'
      hosting = Hosting.create!(:product => self.product, :account => order.account)
      hosting.activate
    when 'domain'
      domain = Domain.create!(:product => self.product, :account => order.account, :name => self.product.name)
    when 'add-on'
      #TODO create add-on and attach to Hosting
    end
  end
  
end
