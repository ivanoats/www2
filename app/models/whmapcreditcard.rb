class Whmapcreditcard < Whmap
  set_primary_key "ccid"
  set_table_name "authnet_master_cc"
  belongs_to :whmapuser, :foreign_key => "uid"
end