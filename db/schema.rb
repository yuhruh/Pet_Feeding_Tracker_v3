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

ActiveRecord::Schema[8.0].define(version: 2025_08_14_075116) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "connected_services", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_connected_services_on_user_id"
  end

  create_table "dry_foods", force: :cascade do |t|
    t.string "brand"
    t.string "description"
    t.decimal "amount"
    t.decimal "used_amount"
    t.decimal "average_used_amount"
    t.decimal "total_ate_amount"
    t.decimal "left_amount"
    t.integer "tracker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "days_remaining"
  end

  create_table "pets", force: :cascade do |t|
    t.string "petname"
    t.datetime "birthday"
    t.decimal "weight"
    t.string "gender"
    t.string "breed"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "trackers", force: :cascade do |t|
    t.date "date"
    t.time "feed_time"
    t.string "come_back_to_eat_time"
    t.string "brand"
    t.string "description"
    t.string "hungry"
    t.decimal "amount", precision: 5, scale: 2
    t.decimal "left_amount", precision: 5, scale: 2
    t.string "result"
    t.string "note"
    t.integer "pet_id"
    t.decimal "weight", precision: 4, scale: 2
    t.decimal "total_ate_amount", precision: 5, scale: 2
    t.integer "favorite_score", default: 0
    t.integer "frequency"
    t.string "love"
    t.date "transformed_date"
    t.time "transformed_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "food_type"
    t.integer "dry_food_id"
    t.index ["dry_food_id"], name: "index_trackers_on_dry_food_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "timezone"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "connected_services", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "trackers", "dry_foods"
end
