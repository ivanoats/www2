class TicketsController < ApplicationController
  include ModelControllerMethods
  
  require_role "Administrator", :only => [:index, :destroy, :enable]

  before_filter :login_required, :only => [:edit, :update]
  
  ssl_required :new, :create, :edit, :update

  sortable_table Ticket
  
  def index
    get_sorted_objects(params, :per_page => 50, :table_headings => [
    ['Subject', 'subject'], ['User','cpanel_username'], ['Email','email'], ['Domain', 'domain_name']])
    render :layout => 'admin'
  end

  
end
