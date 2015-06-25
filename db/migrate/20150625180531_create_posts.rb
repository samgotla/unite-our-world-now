class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :forum_id
      t.string :subject
      t.integer :user_id
      t.string :body
      t.boolean :approved, default: false
      t.timestamps null: false
    end
  end
end
