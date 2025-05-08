class AddActivityColumnsToLessons < ActiveRecord::Migration[8.0]
  def change
    change_column :lessons, :markdown_content, :text, default: ''

    change_table :lessons, bulk: true do |t|
      t.string :activity_type
      t.string :question
      t.string :expected_answer
      t.string :user_answer
    end
  end
end
