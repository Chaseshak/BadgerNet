class AddSendTypeToAnnouncement < ActiveRecord::Migration[5.1]
  def change
    add_column :announcements, :sendType, :string
  end
end
