class Whmaphostingorder < Whmap
  set_primary_key "oid"
  set_table_name "hosting_order"
  belongs_to :whmapuser, :foreign_key => "uid"
  has_many :whmapinvoice, :foreign_key => "oid"
end