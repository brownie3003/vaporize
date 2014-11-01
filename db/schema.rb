# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141101162721) do

  create_table "addresses", force: true do |t|
    t.string   "house_number"
    t.string   "street"
    t.string   "second_line"
    t.string   "city"
    t.string   "county"
    t.string   "postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_id"
  end

  add_index "addresses", ["subscription_id"], name: "index_addresses_on_subscription_id"

  create_table "eliquids", force: true do |t|
    t.string   "name"
    t.string   "volume"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscription_choices", force: true do |t|
    t.integer  "subscription_id"
    t.integer  "eliquid_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscription_plans", force: true do |t|
    t.string   "name"
    t.integer  "eliquid_count"
    t.integer  "interval_cost"
    t.string   "interval"
    t.integer  "initial_cost"
    t.integer  "initial_interval_count"
    t.integer  "ecigarette_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bottle_count_description"
    t.string   "equivalent_cigarettes_description"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "shipping_day"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "initial_ecigarette"
    t.string   "stripe_token"
    t.integer  "subscription_plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
