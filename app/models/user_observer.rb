class UserObserver < ActiveRecord::Observer

  def before_save(user)
    # Cache compiled Markdown
    user.profile_html = Maruku.new(user.profile).to_html
  end

end
