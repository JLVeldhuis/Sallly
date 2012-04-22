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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120305160113) do

  create_table "events", :force => true do |t|
    t.string   "title"
    t.datetime "date_from"
    t.datetime "date_to"
    t.string   "location"
    t.string   "eventtype"
    t.string   "crm"
    t.string   "tips"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.integer  "goal_revenue"
    t.date     "goal_start"
    t.date     "goal_end"
    t.integer  "average_revenue"
    t.date     "average_start"
    t.date     "average_end"
    t.integer  "activity_level"
    t.integer  "activity_calls"
    t.integer  "activity_visits"
    t.integer  "activity_quotes"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
