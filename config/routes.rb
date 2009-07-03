ActionController::Routing::Routes.draw do |map|
  map.resources :authors, :only => [ :index, :show ]
  map.resources :priorities, :only => [ :index, :show ]
  map.resources :reviews
  map.resources :tags, :only => [ :index, :show ]
  map.resources :task_views, :only => [ :index, :show ]
  map.resources :timeline_events, :only => [ :index, :show ]
  map.resources :users
  map.resources :versions, :only => [ :index ], :collection => { :feed => :get }

  map.resources :packages,
                :collection => { :all => :get, :feed => :get },
                :member => { :index => :post },
                :except => [ :create, :update, :edit ] do |p|
    p.resources :versions, :only => [ :show ] do |v|
      v.resources :reviews
    end
    p.resources :ratings, :except => [ :edit, :update ]
    p.resources :reviews
    p.resources :taggings, :only => [ :new, :create, :destroy ]
  end

  # Singleton resources
  map.resource :search, :controller => "search", :only => [ :show ]
  map.resource :session, :collection => { :rpx_now => :get },
                         :except => [ :update, :edit ]

  map.root :controller => "welcome", :action => "index"

  map.with_options :controller => "static" do |static|
    static.about "about", :action => "about"
    static.error_404 "error_404", :action => "error_404"
    static.error_500 "error_500", :action => "error_500"
  end

  map.signup   '/signup', :controller => 'users', :action => 'new'
  map.thanks   '/thanks', :controller => 'users', :action => 'signup'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.login    '/login', :controller => 'sessions', :action => 'new'
  map.logout   '/logout', :controller => 'sessions', :action => 'destroy'

  map.connect ':controller/:action/:id.:format'

  map.error '*url', :controller => 'static', :action => 'error_404'
end
