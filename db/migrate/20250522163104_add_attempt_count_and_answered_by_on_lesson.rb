class AddAttemptCountAndAnsweredByOnLesson < ActiveRecord::Migration[8.0]
  def change
    change_table :lessons, bulk: true do |t|
      t.integer :attempt_count, default: 0
      t.boolean :is_correct, default: false
    end
  end

  def down
    change_table :lessons, bulk: true do |t|
      t.remove :attempt_count
      t.remove :is_correct
    end
  end
end
