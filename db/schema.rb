# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_14_043440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "loyalty_tiers", force: :cascade do |t|
    t.integer "points_required"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monthly_points", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "points", default: 0
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_monthly_points_on_user_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.string "name"
    t.string "criteria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "leftover_spent_in_cents"
    t.integer "total_spent_in_cents"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "user_rewards", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "reward_id"
    t.string "identifier"
    t.boolean "redeemed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_user_rewards_on_reward_id"
    t.index ["user_id"], name: "index_user_rewards_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "country", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "loyalty_tier_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["loyalty_tier_id"], name: "index_users_on_loyalty_tier_id"
  end

end
