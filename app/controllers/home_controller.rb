# HomeController controls the home-page (For all roles)
class HomeController < ApplicationController
  def index
    @announcements = Announcement.scoped(current_user, limit: 5)
    @documents = Document.scoped(current_user, limit: 5)
    if current_user.has_role? :coach
      render 'admin_index'
    else
      render
    end
  end
end
