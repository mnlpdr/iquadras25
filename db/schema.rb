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

ActiveRecord::Schema[8.0].define(version: 2025_03_20_034019) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "bulletin_board_posts", force: :cascade do |t|
    t.string "username", null: false
    t.string "contact", null: false
    t.text "message", null: false
    t.string "sport", null: false
    t.date "date", null: false
    t.integer "players_needed", default: 1
    t.string "location"
    t.time "preferred_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_bulletin_board_posts_on_date"
    t.index ["sport"], name: "index_bulletin_board_posts_on_sport"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.string "address"
    t.date "birthdate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_clients_on_email", unique: true
  end

  create_table "court_owners", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone_number", null: false
    t.string "address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_court_owners_on_email", unique: true
  end

  create_table "court_sports", force: :cascade do |t|
    t.bigint "court_id", null: false
    t.bigint "sport_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_id", "sport_id"], name: "index_court_sports_on_court_id_and_sport_id", unique: true
    t.index ["court_id"], name: "index_court_sports_on_court_id"
    t.index ["sport_id"], name: "index_court_sports_on_sport_id"
  end

  create_table "courts", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.decimal "price_per_hour", precision: 10, scale: 2
    t.float "latitude"
    t.float "longitude"
    t.index ["owner_id"], name: "index_courts_on_owner_id"
  end

  create_table "courts_sports", id: false, force: :cascade do |t|
    t.bigint "court_id", null: false
    t.bigint "sport_id", null: false
    t.index ["court_id", "sport_id"], name: "index_courts_sports_on_court_id_and_sport_id"
    t.index ["sport_id", "court_id"], name: "index_courts_sports_on_sport_id_and_court_id"
  end

  create_table "notification_logs", force: :cascade do |t|
    t.string "notification_type"
    t.bigint "user_id"
    t.bigint "reservation_id"
    t.string "status"
    t.text "error_message"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_type"], name: "index_notification_logs_on_notification_type"
    t.index ["reservation_id"], name: "index_notification_logs_on_reservation_id"
    t.index ["status"], name: "index_notification_logs_on_status"
    t.index ["user_id"], name: "index_notification_logs_on_user_id"
  end

  create_table "payment_service_payments", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "status", default: 0
    t.string "stripe_payment_intent_id"
    t.string "stripe_payment_id"
    t.integer "reservation_id", null: false
    t.integer "user_id", null: false
    t.json "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_payment_service_payments_on_reservation_id"
    t.index ["stripe_payment_intent_id"], name: "index_payment_service_payments_on_stripe_payment_intent_id", unique: true
    t.index ["user_id"], name: "index_payment_service_payments_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.bigint "user_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "status", default: 0
    t.string "stripe_payment_id"
    t.string "stripe_payment_intent_id"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_payments_on_reservation_id"
    t.index ["stripe_payment_id"], name: "index_payments_on_stripe_payment_id", unique: true
    t.index ["stripe_payment_intent_id"], name: "index_payments_on_stripe_payment_intent_id", unique: true
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "court_id", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "status", default: 0
    t.index ["court_id"], name: "index_reservations_on_court_id"
    t.index ["status"], name: "index_reservations_on_status"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "sports", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sports_on_name", unique: true
  end

  create_table "test_enums", force: :cascade do |t|
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role", default: 0, null: false
    t.string "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "court_sports", "courts"
  add_foreign_key "court_sports", "sports"
  add_foreign_key "courts", "users", column: "owner_id"
  add_foreign_key "notification_logs", "reservations", on_delete: :nullify
  add_foreign_key "notification_logs", "users"
  add_foreign_key "payments", "reservations"
  add_foreign_key "payments", "users"
  add_foreign_key "reservations", "courts"
  add_foreign_key "reservations", "users"
end
