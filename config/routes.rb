ActionController::Routing::Routes.draw do |map|
  
  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup-new', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
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
  map.resources :products
  map.resources :tags
  map.resources :tickets
  map.resources :certificate_tickets
  map.resources :subscriptions
  map.resources :invoices
  map.resources :comments
  
  map.resources :pages
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
  map.blog '/blog', :controller => 'articles', :action => 'index'
  map.help '/help', :controller => 'tickets', :action => 'new'
  map.support '/support', :controller => 'tickets', :action => 'new'
  map.kb '/kb', :controller => 'articles', :action => 'index', :category_id => 2
  map.faq '/faq', :controller => 'articles', :action => 'index', :category_id => 2
  map.knowledgebase '/knowledgebase', :controller => 'articles', :action => 'index', :category_id => 2
  map.search '/search/:search', :controller => 'articles', :action => 'search'
  map.certificate_ticket '/certificate_signing_request', :controller => 'certificate_tickets', :action => "new"
  # Home Page
  map.root :controller => 'pages', :action => 'home'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  # 404 handler
  map.connect '*path', :controller => 'four_oh_fours'
end
