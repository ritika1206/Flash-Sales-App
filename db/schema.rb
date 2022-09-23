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

ActiveRecord::Schema[7.0].define(version: 2022_09_23_062245) do
  create_table "table_deals", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "price_in_cents"
    t.integer "discount_price_in_cents"
    t.integer "quantity"
    t.boolean "is_publishable"
    t.decimal "tax_percentage"
    t.integer "created_by"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "role", default: "user"
    t.datetime "verified_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "verification_token"
  end

  add_foreign_key "table_deals", "users", column: "created_by"
end
