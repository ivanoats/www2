class DomainsController < ApplicationController
  layout 'account'

  before_filter :login_required
  before_filter :require_domain
  
  include ModelControllerMethods

  def cancel
    load_object
    @domain.delete!
    flash[:notice] = 'Domain deleted'
    redirect_to :controller => "account", :action => 'hosting'
  end

  private

    def require_domain
      @account = Account.find_by_id(session[:account]) || current_user.accounts.first
      redirect_to root_url and flash[:error] = "An account is required to view this page" if @account.nil?
    end

    def scoper
      @account.domains
    end
end
