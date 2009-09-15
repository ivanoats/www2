class Purchase < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  
  serialize :data, Hash
  
  acts_as_tree
  
  def redeem
    case self.product.kind
    when 'package'
      hosting = Hosting.new({:product => self.product, :account => order.account})
      
      self.children.each do |child|
        case child.product.kind
        when 'domain'
          hosting.domains << Domain.new(:product => child.product, :account => order.account, :name => child.data[:domain], :purchased => child.product.cost > 0)
          
        when 'addon'
          hosting.add_ons << AddOn.new(:product => child.product, :account => order.account)
        end
      end
      hosting.generate_username
      hosting.generate_password
      hosting.save
      hosting.activate
    when 'domain'
      domain = Domain.create(:product => self.product, :account => order.account, :name => self.data[:domain], :purchased => self.product.cost > 0)
    when 'addon'
      add_on = AddOn.create(:product => self.product, :account => order.account)
    end
  end
  
end
