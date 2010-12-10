class AccountsUsersController < ApplicationController
  before_filter :login_required
  #before_filter :require_account, :except => [:create, :destroy]

  include JoinModelControllerMethods
  
  def add_from_email
    @user = User.find_by_email(params[:user][:email])
    
    @error = "#{@user.email} is already an administrator" if @user && scoper.include?(@user)
    
    unless @user
      @user = User.new(:email => params[:user][:email])
      
      if @user.save
        UserMailer.deliver_admin_notification @user
      else
        @error = @user.errors.full_messages.first
      end
    end

    scoper << @user if @user.valid?
    
    render :update do |page|
      if @error
        page.alert(@error)
      else
        page.insert_html :bottom, :users_table, :partial => 'account/user', :locals => {:user => @user}
        page << "jQuery('#user_email').val('');"
      end
    end
  end
  
protected

  
  def generate_password
    Base64.encode64( Digest::SHA1.digest( "#{ rand( 1<<64 ) }/#{ Time.now.to_f }/#{ Process.pid }" ) )[0..7]
  end
    
end
