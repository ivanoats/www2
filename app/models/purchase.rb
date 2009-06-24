class Purchase < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :purchasable, :polymorphic => true
  
  serialize :data, Hash
  
  def redeem
    case product.kind
    when 'package'
      hosting = Hosting.create(data.merge({:product => self.product, :account => order.account}))
      hosting.activate
    when 'domain'
      domain = Domain.create(:product => self.product, :account => order.account, :name => self.data[:domain])
    when 'add-on'
      add_on = AddOn.create(:product => self.product, :account => order.account)
    end
  end
  
end
