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

ActiveRecord::Schema[7.0].define(version: 2022_07_21_195855) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.bigint "available_on_date_id", null: false
    t.bigint "address_id", null: false
    t.index ["address_id"], name: "index_hotels_on_address_id"
    t.index ["available_on_date_id"], name: "index_hotels_on_available_on_date_id"
    t.index ["feature_id"], name: "index_hotels_on_feature_id"
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

  add_foreign_key "hotels", "addresses"
  add_foreign_key "hotels", "available_on_dates"
  add_foreign_key "hotels", "features"
  add_foreign_key "reservations", "hotels"
  add_foreign_key "reservations", "users"
end
