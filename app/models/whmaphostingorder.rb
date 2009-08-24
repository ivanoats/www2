class Whmaphostingorder < Whmap
  set_primary_key "oid"
  set_table_name "hosting_order"
  belongs_to :whmapuser, :foreign_key => "uid"
  belongs_to :whmapserver, :foreign_key => "whm_id"
  has_many :whmapinvoice, :foreign_key => "oid"
  belongs_to :whmappackage, :foreign_key => "pid"
  
  named_scope :active, :conditions => {:status => 1}
  named_scope :suspended, :conditions => {:status => 2}
  named_scope :cancelled, :conditions => "reason_for_cancel != '' " # status == 5?  
  
  def formatted_payment_method
    case self.payment_method.to_i
      when 8 then "Authorize.net"
      when 6 then "2Checkout"
      when 4 then "Mail in"
      when 1 then "PayPal"
    end
  end
  
  
end

