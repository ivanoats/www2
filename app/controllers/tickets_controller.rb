class TicketsController < ApplicationController
  include ModelControllerMethods
  
  require_role "Administrator", :only => [:index, :destroy, :enable]

  before_filter :login_required, :only => [:edit, :update]
  
  ssl_required :new, :create, :edit, :update
  
end
