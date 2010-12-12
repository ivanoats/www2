class RolesController < ApplicationController 
  require_role :Administrator
  
  def index 
    @user = User.find(params[:user_id]) 
    @all_roles = Role.find(:all) 
  end 
 
  def update 
    @user = User.find(params[:user_id]) 
    @role = Role.find(params[:id]) 
    unless @user.has_role?(@role.name) 
      @user.roles << @role 
    end 
    redirect_to :action => 'index' 
  end

  def destroy 
    @user = User.find(params[:user_id]) 
    @role = Role.find(params[:id]) 
    if @role.name == 'Administrator' && @role.users.count == 1
      
      flash[:error] = "Cannot delete all administrators, you are trying to delete the last one"
      redirect_to :action => 'index'
      return
    end
    if @user.has_role?(@role.name) 
      @user.roles.delete(@role) 
    end 
    redirect_to :action => 'index' 
  end 
end 
  