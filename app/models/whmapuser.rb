class Whmapuser < Whmap
  set_primary_key "uid"
  set_table_name "user"
  has_many :whmaphostingorder, :foreign_key => "uid"
  has_many :whmapinvoice, :foreign_key => "uid"
  has_many :whmapcreditcard, :foreign_key => "uid"
  
  has_one :whmapcreditcard, :foreign_key => "uid", :conditions => {:master_cc => 1}
end