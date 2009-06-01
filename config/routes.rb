ActionController::Routing::Routes.draw do |map|
  map.resources :authors
  map.resources :reviews
  map.resources :tags
  map.resources :taggings
  map.resources :users

  map.resources :packages, :collection => {:all => :get}, :member => {:index => :post}, :except => [:create, :update] do |p|
    p.resources :versions
    p.resources :ratings
    p.resources :reviews
  end

  map.resource  :search, :controller => "search"
  map.resource  :session

  map.root :controller => "about", :action => "index"

  map.signup   '/signup', :controller => 'users', :action => 'new'
  map.thanks   '/thanks', :controller => 'users', :action => 'signup'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.login    '/login', :controller => 'sessions', :action => 'new'
  map.logout   '/logout', :controller => 'sessions', :action => 'destroy'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
