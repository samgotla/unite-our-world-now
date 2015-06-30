class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :body
      t.boolean :approved, default: false
      t.timestamps
    end
  end
end
