class Purchase < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :purchasable, :polymorphic => true
  def redeem
    case product.kind
    when 'package'
      hosting = Hosting.new(:product => self.product)
      hosting.activate
      order.account.hostings << hosting
    when 'add-on'
      #TODO create add-on and attach to Hosting
    end
  end
  
end
