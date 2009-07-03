class WhmapinvoiceController < ApplicationController
  
  layout "whmap_active_scaffold"
  active_scaffold :whmapinvoice
  require_role "Administrator"
  before_filter :login_required
  
end
