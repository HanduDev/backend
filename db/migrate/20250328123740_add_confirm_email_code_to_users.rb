class AddConfirmEmailCodeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :confirm_email_code, :string
    add_column :users, :confirm_email_code_sent_at, :datetime
    add_column :users, :confirmed_email_at, :datetime
  end
end
