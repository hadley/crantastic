class UserSession < Authlogic::Session::Base

  single_access_allowed_request_types :all # TODO: narrow down
  # ["application/rss+xml", "application/atom+xml"]

end
