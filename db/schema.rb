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

ActiveRecord::Schema.define(version: 20160503063247) do

  create_table "ads", force: :cascade do |t|
    t.integer  "area_id",    limit: 4
    t.string   "url",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "user_id",    limit: 4
    t.decimal  "distance",               precision: 10, scale: 4
  end

  create_table "area_infos", force: :cascade do |t|
    t.integer  "area_id",    limit: 4
    t.string   "area_info",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "areas", force: :cascade do |t|
    t.integer  "area_id",    limit: 4
    t.decimal  "latitude",             precision: 13, scale: 10
    t.decimal  "longitude",            precision: 13, scale: 10
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "campaign_infos", force: :cascade do |t|
    t.integer  "campaign_id", limit: 4
    t.integer  "area_id",     limit: 4
    t.integer  "ad_id",       limit: 4
    t.decimal  "total_time",            precision: 10, scale: 2
    t.decimal  "distance",              precision: 10, scale: 2
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "days",        limit: 4
  end

  add_index "campaign_infos", ["ad_id", "area_id", "campaign_id"], name: "index_campaign_infos_on_ad_id_and_area_id_and_campaign_id", unique: true, using: :btree

  create_table "campaign_runs", force: :cascade do |t|
    t.integer "campaign_info_id", limit: 4
    t.date    "date"
    t.decimal "total_time",                 precision: 10, scale: 2, default: 0.0
    t.decimal "exhausted_time",             precision: 10, scale: 2, default: 0.0
    t.decimal "distance",                   precision: 10, scale: 5, default: 0.0
  end

  add_index "campaign_runs", ["campaign_info_id", "date"], name: "index_campaign_runs_on_campaign_info_id_and_date", unique: true, using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.date     "start_date"
    t.string   "name",       limit: 255
    t.boolean  "active",     limit: 1,   default: false
  end

  add_index "campaigns", ["user_id", "name"], name: "index_campaigns_on_user_id_and_name", unique: true, using: :btree

  create_table "coordinates", force: :cascade do |t|
    t.string   "user_id",    limit: 255
    t.decimal  "latitude",               precision: 15, scale: 10
    t.decimal  "longitude",              precision: 15, scale: 10
    t.integer  "ad_id",      limit: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "area_id",    limit: 4
    t.datetime "recordtime"
    t.string   "polyline",   limit: 255
    t.string   "device_id",  limit: 255
    t.integer  "processed",  limit: 4
  end

  add_index "coordinates", ["device_id", "recordtime"], name: "index_coordinates_on_device_id_and_recordtime", using: :btree

  create_table "ncoordinates", force: :cascade do |t|
    t.string   "user_id",    limit: 255
    t.decimal  "latitude",               precision: 10
    t.integer  "longitude",  limit: 4
    t.integer  "ad_id",      limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "password",   limit: 255
  end

  create_table "versions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "version",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
