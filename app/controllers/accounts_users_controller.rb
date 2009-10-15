class AccountsUsersController < ApplicationController
  before_filter :login_required
  before_filter :require_account, :except => [:new, :create, :switch_account]
  

  include JoinModelControllerMethods
end
