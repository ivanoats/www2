class ServersController < ApplicationController
  include ModelControllerMethods
  
  sortable_table Server
  
  layout 'admin'
  require_role "Administrator"
  
  before_filter :login_required
  
  def index
    load_object


    get_sorted_objects(params, :table_headings => [['Name', 'name'],
    ['IP Address', 'ip_address'], ['Whm User','whm_user']])
    
    
  end
  
  def hostings
    load_object
    @accounts = @server.whm.accounts
    @packages = @server.whm.packages    
  end
end
