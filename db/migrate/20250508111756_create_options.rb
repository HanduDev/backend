class CreateOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :options do |t|
      t.string :content, null: false
      t.boolean :correct, null: false, default: false
      t.references :lesson, null: false, foreign_key: true

      t.timestamps
    end
  end
end
