class AddForumIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :forum_id, :integer
  end
end
