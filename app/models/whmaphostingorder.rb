class Whmaphostingorder < Whmap
  set_primary_key "oid"
  set_table_name "hosting_order"
  belongs_to :whmapuser, :foreign_key => "uid"
  has_many :whmapinvoice, :foreign_key => "oid"
  
  def formatted_payment_method
    case self.payment_method.to_i
      when 8 then "Authorize.net"
      when 6 then "2Checkout"
      when 4 then "Mail in"
      when 1 then "PayPal"
    end
  end
  
end