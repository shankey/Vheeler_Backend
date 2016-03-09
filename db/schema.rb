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

ActiveRecord::Schema.define(version: 20160309093719) do

  create_table "ads", force: :cascade do |t|
    t.integer  "area_id",    limit: 4
    t.string   "url",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",    limit: 4
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

  create_table "coordinates", force: :cascade do |t|
    t.string   "user_id",    limit: 255
    t.decimal  "latitude",               precision: 15, scale: 10
    t.decimal  "longitude",              precision: 15, scale: 10
    t.integer  "ad_id",      limit: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "area_id",    limit: 4
    t.datetime "recordtime"
  end

  create_table "ncoordinates", force: :cascade do |t|
    t.string   "user_id",    limit: 255
    t.decimal  "latitude",               precision: 10
    t.integer  "longitude",  limit: 4
    t.integer  "ad_id",      limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "version",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
