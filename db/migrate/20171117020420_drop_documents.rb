class DropDocuments < ActiveRecord::Migration[5.1]
  def change
    drop_table :documents
  end
end
