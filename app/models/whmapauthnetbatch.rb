#
# An Authorize.net batch 
class Whmapauthnetbatch < Whmap
  set_primary_key "bid"
  set_table_name "authnet_batch"
  has_many :whmaphostingorder, :foreign_key => "oid"
  has_many :whmapinvoice, :foreign_key => "invoice_number"
  
  def original_create
    Time.at(self.ogcreate).strfttime('%Y-%m-%d')
  end
end