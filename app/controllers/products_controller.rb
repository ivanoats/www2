class ProductsController < ApplicationController
  include ModelControllerMethods
  
  layout 'admin'
  require_role "Administrator"
  
  before_filter :login_required
  
  sortable_table Product
  def index
    get_sorted_objects(params, :per_page => 50, :table_headings => [
    ['Name', 'name'], ['Kind','kind'], ['Status','status']])  
  end
  
end
