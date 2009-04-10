class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem
  include SslRequirement

  helper :all # include all helpers, all the time
  protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  protected
  
  # Automatically respond with 404 for ActiveRecord::RecordNotFound
  def record_not_found
    render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
  end
  
  def affiliate_check
    # see if there is an existing affiliate cookie
    existing_affiliate = cookies[:referrer_id]
    # if there isn't an existing affiliate cookie and there is a referrer id in query string
    if !params['referrer_id'].nil? and existing_affiliate.blank?   
      cookie_hash = { 
        :value => params['referrer_id'],
        :expires => 90.days.from_now
      }
      cookie_hash[:domain] = '.sustainablewebsites.com' if ENV['RAILS_ENV'] != 'development'
      #cookie_hash[:domain] = 'localhost:3000'    # does not seem to work in development
      cookies[:referrer_id] = cookie_hash  
      puts cookies[:referrer_id]
    end
    
  end

  def require_account
    user = current_user

    flash[:error] = "User must be logged in" and redirect_to root_url if user.nil?
    flash[:error] = "User doesn't belong to an account" and redirect_to root_url if user.accounts.empty?

    #attempt to load from session
    if(session[:account])
      account = Account.find_by_id(session[:account])
      @account = account and return if account.users.include? user
    end

    #load first account by default
    @account = user.accounts.first
  end

end

