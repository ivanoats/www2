class AccountsController < ApplicationController
  layout 'admin'

  before_filter :login_required  
  require_role "Administrator"
  
  include ModelControllerMethods

end
