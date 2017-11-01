class AddSmsToAnnouncement < ActiveRecord::Migration[5.1]
  def change
    add_column :announcements, :sms, :boolean
  end
end
