ActionController::Routing::Routes.draw do |map|

  map.resources :author_identities, :only => [ :new, :create ]
  map.resources :authors, :only => [ :index, :show, :edit, :update ]
  map.resources :password_resets, :except => [ :index, :destroy, :show ]
  map.resources :priorities, :only => [ :index, :show ], :controller => "tags",
                             :requirements => { :type => "priority" }
  map.resources :tags, :only => [ :index, :show, :edit, :update ]
  map.resources :task_views, :only => [ :index, :show ], :controller => "tags",
                             :requirements => { :type => "task_view" }
  map.resources :timeline_events, :only => [ :index, :show ]
  map.resources :users, :except => [ :destroy ]
  map.resources :versions, :only => [ :index ], :collection => { :feed => :get }
  map.resources :votes, :only => [ :create ]
  map.resources :weekly_digests, :only => :show

  # Nested resources
  map.resources :packages,
                :collection => { :all => :get, :feed => :get },
                :member => { :toggle_usage => :post },
                :except => [ :create, :update, :edit ] do |p|
    p.resources :versions, :only => [ :show ]
    p.resources :ratings, :except => [ :edit, :update ]
    p.resources :reviews
    p.resources :taggings, :only => [ :new, :create, :destroy ]
  end

  map.resources :reviews, :only => [ :index, :show ] do |r|
    r.resources :review_comments, :only => [ :new, :create, :show ]
  end

  # Singleton resources
  map.resource :search, :controller => "search", :only => [ :show ]
  map.resource :session, :collection => { :rpx_token => :get },
                         :only => [ :new, :create, :destroy ]

  map.root :controller => "welcome", :action => "index"

  map.with_options :controller => "static" do |static|
    static.about "about", :action => "about"
    static.email_notifications "email_notifications", :action => "email_notifications"
    static.error_404 "error_404", :action => "error_404"
    static.error_500 "error_500", :action => "error_500"
  end

  # Named routes
  map.signup   '/signup', :controller => 'users', :action => 'new'
  map.thanks   '/thanks', :controller => 'users', :action => 'signup'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.login    '/login', :controller => 'sessions', :action => 'new'
  map.logout   '/logout', :controller => 'sessions', :action => 'destroy'

  map.connect ':controller/:action/:id.:format'

  map.error '*url', :controller => 'static', :action => 'error_404'

end
