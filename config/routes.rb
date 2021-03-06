ActionController::Routing::Routes.draw do |map|
  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup-new', :controller => 'users', :action => 'new'
  map.order '/order', :controller => 'green_hosting_store', :action => 'index'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.activate '/activate_admin/:activation_code', :controller => 'users', :action => 'activate_admin', :activation_code => nil
  map.profile '/profile', :controller => 'users', :action => 'profile'
  #map.profile '/profile', :controller => 'users', :action => 'edit'
  
  
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }
  
  # Restful Authentication Resources
  map.resources :users
  map.resources :passwords
  map.resource :session
  
  map.resources :users, :member => { :enable => :put } do |users| 
    users.resources :roles 
  end
  
  # Application Resources
  map.resources :redirects
  map.resources :hostings
  map.resources :servers
  map.resources :products
  map.resources :tags
  map.resources :tickets
  map.resources :certificate_tickets
  map.resources :subscriptions
  map.resources :invoices
  map.resources :comments
  map.resources :pages
  map.resources :accounts
  map.resources :domains
  map.resources :orders
  map.resources :whmapuser         # ,  :active_scaffold => true
  map.resources :whmaphostingorder # ,  :active_scaffold => true
  map.resources :whmapinvoice      #,  :active_scaffold => true

  map.manage_account '/account/manage', :controller => 'account', :action => 'manage'
  
  map.page_permalink '/page/:permalink', :controller => 'pages', :action => 'permalink'
  
  map.resources :articles, :collection => {:admin => :get}
  map.permalink 'article/:permalink', :controller => 'articles', :action => 'permalink'
  map.connect 'article/:permalink.:format', :controller => 'articles', :action => 'permalink', :format => nil
  
  map.resources :categories, :collection => {:admin => :get} do |categories| 
    categories.resources :articles, :name_prefix => 'category_' 
  end
  
  map.show_user '/user/:login', 
                  :controller => 'users', 
                  :action => 'show_by_login'
  
  # Shortcut Routes
  map.admin '/administration', :controller => 'admin', :action => 'index'
  map.blog '/blog', :controller => 'articles', :action => 'index'
  map.help '/help', :controller => 'tickets', :action => 'new'
  map.support '/support', :controller => 'tickets', :action => 'new'
  map.kb '/kb', :controller => 'articles', :action => 'index', :category_id => 2
  map.faq '/faq', :controller => 'articles', :action => 'index', :category_id => 2
  map.knowledgebase '/knowledgebase', :controller => 'articles', :action => 'index', :category_id => 2
  map.livesearch '/search/:search', :controller => 'articles', :action => 'livesearch', :search => nil
  map.certificate_signing_request '/certificate_signing_request', :controller => 'certificate_tickets', :action => "new"
  map.switch_account '/switch_account/:id', :controller => "account", :action => 'switch_account'
  # Home Page
  map.root :controller => 'pages', :action => 'home'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  # 404 handler
  map.connect '*path', :controller => 'four_oh_fours'
end
