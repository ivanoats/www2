class HostingsController < ApplicationController

  layout 'account'
  before_filter :login_required
  before_filter :require_account
  
  include ModelControllerMethods
  
  def cancel
    load_object
    @hosting.delete!
    flash[:notice] = 'Web hosting package cancelled'
    redirect_to :controller => "account", :action => 'hosting'
  end
  
private

  def scoper
    @account.hostings
  end
  
  
end
