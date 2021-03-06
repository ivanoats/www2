class ServersController < ApplicationController
  include ModelControllerMethods
  
  sortable_table Server
  
  layout 'admin'
  require_role "Administrator"
  
  before_filter :login_required
  
  def index
    get_sorted_objects(params, :table_headings => [['Name', 'name'],
    ['IP Address', 'ip_address'], ['Whm User','whm_user']])
    

  end
  
  def hostings
    load_object
    @accounts = @server.whm.accounts
  rescue Whm::CommandFailedError => e
    flash[:error] = "Failed to load whm accounts because whm returned '#{e.to_s}'"
    @accounts = []
  end
  
  def packages
    load_object
    @packages = @server.whm.packages   
     
  rescue Whm::CommandFailedError => e
    flash[:error] = "Failed to load whm packages because whm returned '#{e.to_s}'"
    @packages = []
  end
  
  def delete_unmanaged
    load_object
    @account = @server.whm.account(params[:account])
    @account.terminate!
    flash[:notice] = "Account deleted"
    redirect_to :action => "hostings", :id => @server
  end
  
end
