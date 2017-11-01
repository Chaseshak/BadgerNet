class RemoveSendTypeFromAnnouncement < ActiveRecord::Migration[5.1]
  def change
    remove_column :announcements, :sendType, :string
  end
end
