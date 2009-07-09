class Permissions < Aegis::Permissions

  default_role :user
  role         :moderator
  role         :administrator, :default_permission => :allow

  permission :edit do |user, obj|
    allow :user do
      obj.user == user # registered users may only edit their own objects
    end
    allow :moderator # moderators may edit any object
  end

  permission :read do |user, obj|
    allow :everyone
  end

end
