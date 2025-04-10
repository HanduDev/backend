class CreateLessons < ActiveRecord::Migration[8.0]
  def change
    create_table :lessons do |t|
      t.references :trail, null: false, foreign_key: true
      t.string :name, null: false
      t.string :markdown_content, null: false
      t.boolean :has_finished, null: false, default: false
      t.datetime :finished_at

      t.timestamps
    end
  end
end
