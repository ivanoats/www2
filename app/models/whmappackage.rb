class Whmappackage < Whmap
  set_primary_key "pid"
  set_table_name "plan_specs"
  has_many :whmaphostingorder, :foreign_key => "pid"
  
end
