class RedirectsController < ApplicationController
  include ModelControllerMethods
  
  layout 'admin'
  require_role "Administrator"
  
end
