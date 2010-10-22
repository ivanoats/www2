class WhmaphostingorderController < ApplicationController
  
  layout "whmap_active_scaffold"
#  active_scaffold :whmaphostingorder
  require_role "Administrator"
  before_filter :login_required
  
end
