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

ActiveRecord::Schema[7.0].define(version: 2022_07_26_203129) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "addresses", force: :cascade do |t|
    t.string "country"
    t.string "state"
    t.string "city"
    t.string "neighbourhood"
    t.string "street"
    t.integer "number"
    t.string "complement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "available_on_dates", force: :cascade do |t|
    t.date "date"
    t.integer "rooms_occopied"
    t.boolean "available"
    t.integer "rooms_free"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "hotel_id", null: false
    t.index ["hotel_id"], name: "index_available_on_dates_on_hotel_id"
  end

  create_table "features", force: :cascade do |t|
    t.integer "room"
    t.boolean "pool"
    t.boolean "bar"
    t.boolean "air_conditioning"
    t.boolean "tv"
    t.boolean "gym"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "feature_id", null: false
    t.bigint "address_id", null: false
    t.bigint "user_id", null: false
    t.index ["address_id"], name: "index_hotels_on_address_id"
    t.index ["feature_id"], name: "index_hotels_on_feature_id"
    t.index ["user_id"], name: "index_hotels_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "reserved_rooms"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "hotel_id", null: false
    t.index ["hotel_id"], name: "index_reservations_on_hotel_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "available_on_dates", "hotels"
  add_foreign_key "hotels", "addresses"
  add_foreign_key "hotels", "features"
  add_foreign_key "hotels", "users"
  add_foreign_key "reservations", "hotels"
  add_foreign_key "reservations", "users"
end
