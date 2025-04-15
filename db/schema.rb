# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_14_233225) do
  create_table "ai_responses", force: :cascade do |t|
    t.text "user_prompt", null: false
    t.text "system_prompt"
    t.text "output", null: false
    t.integer "total_tokens", null: false
    t.string "model", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_ai_responses_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.integer "trail_id", null: false
    t.string "name", null: false
    t.string "markdown_content", null: false
    t.boolean "has_finished", default: false, null: false
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trail_id"], name: "index_lessons_on_trail_id"
  end

  create_table "trails", force: :cascade do |t|
    t.string "name", null: false
    t.date "started_at"
    t.string "language", null: false
    t.text "description", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "themes", default: "", null: false
    t.string "level", default: "", null: false
    t.string "developments", default: "", null: false
    t.string "time_to_learn", default: "", null: false
    t.string "time_to_study", default: "", null: false
    t.index ["user_id"], name: "index_trails_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "google_id"
    t.string "photo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirm_email_code"
    t.datetime "confirm_email_code_sent_at"
    t.datetime "confirmed_email_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.bigint "whodunnit"
    t.datetime "created_at"
    t.bigint "item_id", null: false
    t.string "item_type", null: false
    t.string "event", null: false
    t.text "object", limit: 1073741823
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "ai_responses", "users"
  add_foreign_key "lessons", "trails"
  add_foreign_key "trails", "users"
end
