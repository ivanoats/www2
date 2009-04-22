class Purchase < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  def redeem
    case product.kind
    when 'package'
      hosting = Hosting.new
      hosting.activate
      order.account.hostings << hosting
    when 'add-on'
      #TODO create add-on and attach to Hosting
    end
  end
  
end
