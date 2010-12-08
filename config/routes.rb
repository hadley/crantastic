ActionController::Routing::Routes.draw do |map|

  map.resources :author_identities, :only => [ :new, :create ]
  map.resources :authors, :only => [ :index, :show, :create, :edit, :update ]
  map.resources :password_resets, :except => [ :index, :destroy, :show ]
  map.resources :priorities, :only => [ :index, :show ], :controller => "tags",
                             :requirements => { :type => "priority" }
  map.resources :tags, :only => [ :index, :show, :edit, :update ]
  map.resources :task_views, :only => [ :index, :show ], :controller => "tags",
                             :requirements => { :type => "task_view" }
  map.resources :timeline_events, :only => [ :index, :show ]
  map.resources :users, :except => [ :destroy ],
                        :member => { :regenerate_api_key => [ :get, :post ] }
  map.resources :versions, :only => [ :index, :create ],
                           :collection => { :feed => :get }
  map.resources :votes, :only => [ :create ]
  map.resources :weekly_digests, :only => [ :index, :show ]

  # Nested resources
  # The following rule allows us to capture links such as /packages/data.table,
  # before redirecting them to the correct URL. Note the negative lookahead for
  # valid formats, so that we don't break e.g. .xml urls.
  map.connect '/packages/:id', :controller => 'packages',
    :action => 'show',
    :requirements => { :id => /.+\.(?!xml|atom|html|bibjs).*/ }
  map.resources :packages,
                :collection => { :all => :get, :feed => :get, :search => [ :get, :post ] },
                :member => { :toggle_usage => :post },
                :except => [ :update, :edit ] do |p|
    p.resources :versions, :only => [ :index, :show ]
    p.resources :ratings, :except => [ :edit, :update ]
    p.resources :reviews
    p.resources :taggings, :only => [ :new, :create, :destroy ]
  end

  map.resources :reviews do |r|
    r.resources :review_comments, :only => [ :new, :create, :show ]
  end

  # Singleton resources
  map.resource :search, :controller => "search", :only => [ :show ]
  map.resource :session, :collection => { :rpx_token => :get },
                         :only => [ :new, :create, :destroy ]

  map.root :controller => "timeline_events", :action => "index"

  map.with_options :controller => "static" do |static|
    static.about "about", :action => "about"
    static.email_notifications "email_notifications", :action => "email_notifications"
    static.error_404 "error_404", :action => "error_404"
    static.error_500 "error_500", :action => "error_500"
  end

  # Named routes
  map.daily    '/daily/:day', :controller => 'weekly_digests', :action => 'daily'
  map.signup   '/signup', :controller => 'users', :action => 'new'
  map.thanks   '/thanks', :controller => 'users', :action => 'thanks'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.login    '/login', :controller => 'sessions', :action => 'new'
  map.logout   '/logout', :controller => 'sessions', :action => 'destroy'
  map.popcon   '/popcon', :controller => 'packages', :action => 'index', :popcon => '1'

  map.version_extras '/versions/:id/:action', :controller => 'versions'

  map.error '*url', :controller => 'static', :action => 'error_404'

end
