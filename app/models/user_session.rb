class UserSession < Authlogic::Session::Base

  params_key "token"
  single_access_allowed_request_types :all # TODO: narrow down
  # ["application/rss+xml", "application/atom+xml"]

end
