class AccountsController < ApplicationController
  layout 'admin'

  before_filter :login_required  
  require_role "Administrator"
  
  include ModelControllerMethods
  sortable_table Account
  
  def index
    get_sorted_objects(params, :per_page => 50, :table_headings => [
    ['Organization', 'organization'], ['Status','state'], ['Balance','balance'],['Email','email']])
    
  end
  
  def show
    session[:account] = params[:id] if Account.find_by_id(params[:id])
    redirect_to :controller => :account, :action => :manage
  end
  
end
