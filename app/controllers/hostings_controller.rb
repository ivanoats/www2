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

  def require_account
    @account = Account.find_by_id(session[:account]) || current_user.accounts.first
    redirect_to root_url and flash[:error] = "An account is required to view this page" if @account.nil?
  end

  def scoper
    @account.hostings
  end
end
