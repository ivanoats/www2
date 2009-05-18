class ServersController < ApplicationController
  include ModelControllerMethods
  
  layout 'admin'
  require_role "Administrator"
  
  before_filter :login_required
end
