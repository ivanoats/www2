class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem
  include SslRequirement

  helper :all # include all helpers, all the time
  protect_from_forgery #:secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation, :key
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  EXCEPTIONS_NOT_LOGGED = ['ActionController::UnknownAction',
                           'ActionController::RoutingError',
                           'ActionController::InvalidAuthenticityToken']
  
  protected
  
  def log_error(exc)
     super unless EXCEPTIONS_NOT_LOGGED.include?(exc.class.name)
   end
  
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
    end
  end

  def require_account
    flash[:error] = "User must be logged in" and redirect_to root_url if current_user.nil?
    
    if current_user.has_role?('Administrator')
      @account = Account.find_by_id(session[:account]) || Account.last
    else
      @account = current_user.accounts.find_by_id(session[:account]) || current_user.accounts.first
    end
    
    redirect_to root_url and flash[:error] = "An account is required to view this page" if @account.nil?
    end

end

