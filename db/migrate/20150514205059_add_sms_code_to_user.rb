class AddSmsCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :sms_code, :string
  end
end
