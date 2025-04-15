class AddExtraFieldsToTrail < ActiveRecord::Migration[8.0]
  def change
    add_column :trails, :themes, :string, null: false, default: ''
    add_column :trails, :level, :string, null: false, default: ''
    add_column :trails, :developments, :string, null: false, default: ''
    add_column :trails, :time_to_learn, :string, null: false, default: ''
    add_column :trails, :time_to_study, :string, null: false, default: ''
  end
end
