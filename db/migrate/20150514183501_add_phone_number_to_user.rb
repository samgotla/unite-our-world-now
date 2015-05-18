class AddPhoneNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :sms_confirmed, :boolean, default: false
  end
end
