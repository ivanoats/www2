class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  require_role "Administrator", :only => [:index, :destroy, :enable]
  before_filter :login_required, :only => [:edit, :update]
  
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    if using_open_id?
      authenticate_with_open_id(params[:openid_url], :return_to => open_id_create_url, 
        :required => [:nickname, :email]) do |result, identity_url, registration|
        if result.successful?
          create_new_user(:identity_url => identity_url, :login => registration['nickname'], :email => registration['email'])
        else
          failed_creation(result.message || "Sorry, something went wrong")
        end
      end
    else
      create_new_user(params[:user])
    end
  end
  
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to login_path
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default(root_path)
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default(root_path)
    end
  end
  
  def activate_admin
    logout_keeping_session!
    @user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    
    if request.put? && @user && !@user.active? && @user.state = 'pending' && @user.update_attributes(params[:user])
        #@user.activate!
        flash[:notice] = "Activation complete! Please sign in to continue."
        redirect_to login_path
    elsif params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default(root_path)
    elseif !@user 
      flash[:error]  = "We couldn't find a user for that activation code, please check your email for the correct activation link, or contact support.  "
      redirect_back_or_default(root_path)
    end
  end
  
  def index
    @users = User.find(:all)
  end
  
  def show
    @user = User.find(params[:id])
    @articles = @user.articles.find(:all, :limit => 3, :order => 'created_at DESC')
  end
  
  def edit
    @current_user = logged_in_user
    if @current_user.has_role?('Administrator') && params[:id]
      @user = User.find(params[:id])
    else
      @user = @current_user
    end
  end
  
  def update
    @current_user = logged_in_user
    if @current_user.has_role?('Administrator') && params[:id]
      @user = User.find(params[:id])
    else
      @user = @current_user
    end
    
    if @user.update_attributes(params[:user]) 
      flash[:notice] = "User updated" 
      redirect_to :action => 'show', :id => @user 
    else 
      render :action => 'edit' 
    end 
  end
  
  def show_by_login
    @user = User.find_by_login(params[:login]) 
    @articles = @user.articles.find(:all, :limit => 3, :order => 'created_at DESC')
    render :action => 'show'
  end
  
  def enable
    @user = User.find(params[:id]) 
    if @user.update_attribute(:enabled, true) 
      flash[:notice] = "User enabled" 
    else 
      flash[:error] = "There was a problem enabling this user." 
    end 
    redirect_to :action => 'index'
  end
  
  def disable
    @user = User.find(params[:id]) 
    if @user.update_attribute(:enabled, false) 
      flash[:notice] = "User disabled" 
    else 
      flash[:error] = "There was a problem disabling this user." 
    end 
    redirect_to :action => 'index'
  end
  
  protected
  
  def create_new_user(attributes)
    @user = User.new(attributes)
    if @user && @user.valid?
      if @user.not_using_openid?
        @user.register!
      else
        @user.register_openid!
      end
    end
    
    if @user.errors.empty?
      successful_creation(@user)
    else
      failed_creation
    end
  end
  
  def successful_creation(user)
    redirect_back_or_default(root_path)
    flash[:notice] = "Thanks for signing up!"
    flash[:notice] << " We're sending you an email with your activation code." if @user.not_using_openid?
    flash[:notice] << " You can now login with your OpenID." unless @user.not_using_openid?
  end
  
  def failed_creation(message = 'Sorry, there was an error creating your account')
    flash[:error] = message
    render :action => :new
  end
end
