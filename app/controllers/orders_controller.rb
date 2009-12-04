class OrdersController < ApplicationController

  layout 'admin'
  before_filter :login_required, :except => :show
  before_filter :require_account, :except => :show
  
  
  include ModelControllerMethods
  sortable_table Order

  skip_before_filter :load_object, :only => :show

  
  def index
    get_sorted_objects(params, :per_page => 50, :table_headings => [
    ['Number', 'id'],  ['Status','state']])  
  end
  
  def new
    redirect_to :action => :index
  end
  
  def show
    @order = Order.find_by_token(params[:token])
    flash[:error] = "Order not found" and redirect_to root_url and return unless @order
    @sidebar = false
    render :layout => 'application'
  end

  def create
    redirect_to :action => :index
  end
  
  def update
    redirect_to :action => :index
  end
  
end
