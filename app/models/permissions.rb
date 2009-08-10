class Permissions < Aegis::Permissions

  default_role :user
  role         :moderator
  role         :administrator, :default_permission => :allow

  permission :edit do |user, obj|
    allow :user do
      # users may only edit their own objects
      if obj.respond_to?(:user)
        obj.user == user
      elsif obj.kind_of?(User)
        obj == user
      end
    end
    allow :moderator # moderators may edit any object
  end

  permission :destroy do |user, obj|
    allow :user do
      obj.user == user # users may only destroy their own objects
    end

    allow :moderator do
      obj.user == user # moderators may only destroy their own objects
    end
  end

end
