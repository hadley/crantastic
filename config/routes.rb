ActionController::Routing::Routes.draw do |map|
  map.resources :authors
  map.resources :reviews
  map.resources :tags
  map.resources :taggings
  map.resources :task_views
  map.resources :users
  map.resources :ratings

  map.resources :packages, :collection => {:all => :get}, :member => {:index => :post}, :except => [:create, :update] do |p|
    p.resources :versions do |v|
      v.resources :reviews
    end
    p.resources :ratings
    p.resources :reviews
    p.resources :taggings
    p.resources :tags
  end

  map.resource :search, :controller => "search"
  map.resource :session
  map.connect "session/rpx_token", :controller => "sessions", :action => "rpx_token"

  map.root :controller => "static", :action => "welcome"

  map.with_options :controller => "static" do |static|
    static.about "about", :action => "about"
    static.error_404 "error_404", :action => "error_404"
    static.error_500 "error_500", :action => "error_500"
    static.welcome "welcome", :action => "welcome"
    static.robots "robots.txt", :action => "robots_txt"
  end

  map.signup   '/signup', :controller => 'users', :action => 'new'
  map.thanks   '/thanks', :controller => 'users', :action => 'signup'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.login    '/login', :controller => 'sessions', :action => 'new'
  map.logout   '/logout', :controller => 'sessions', :action => 'destroy'

  map.error '*url', :controller => 'static', :action => 'error_404'
end
