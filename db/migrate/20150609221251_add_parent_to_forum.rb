class AddParentToForum < ActiveRecord::Migration
  def change
    add_column :forums, :parent_id, :integer
  end
end
