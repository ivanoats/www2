class WhmapuserController < ApplicationController
  
  layout "whmap_active_scaffold"
  # active_scaffold :whmapuser
  require_role "Administrator"
  before_filter :login_required
  
end
