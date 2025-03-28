class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :full_name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest
      t.string :google_id
      t.string :photo_url

      t.timestamps
    end
  end
end
