class CreateTrail < ActiveRecord::Migration[8.0]
  def change
    create_table :trails do |t|
      t.string :name, null: false
      t.date :started_at
      t.string :language, null: false
      t.text :description, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
