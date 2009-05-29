class AccountsController < ApplicationController
  layout 'admin'

  before_filter :login_required  
  require_role "Administrator"
  
  include ModelControllerMethods
  
  def show
    session[:account] = params[:id] if Account.find_by_id(params[:id])
    redirect_to :controller => :account, :action => :manage
  end
  
end
