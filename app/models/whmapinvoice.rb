class Whmapinvoice < Whmap
  set_primary_key "iid"
  set_table_name "invoice"
  belongs_to :whmaphostingorder, :foreign_key => "oid"
  belongs_to :whmapuser, :foreign_key => "uid"
end