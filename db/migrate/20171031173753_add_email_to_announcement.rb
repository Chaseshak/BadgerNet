class AddEmailToAnnouncement < ActiveRecord::Migration[5.1]
  def change
    add_column :announcements, :email, :boolean
  end
end
