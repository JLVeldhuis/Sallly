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

ActiveRecord::Schema.define(:version => 20120113165809) do

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.string   "content"
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
  
  create table "calendar_event", :force => true do |t|
    t.datetime "created_at"
    t.datetime "event_date"
    t.datetime "finished_before"
    t.string   "name"
    t.string   "notes"
    t.string   "type"   
    t.boolean  "done"
    t.integer  "user_id"
  end
  
   create table "user_profile", :force => true do |t|
     t.integer   "revenue"
     t.integer   "cold_calls"
     t.integer   "visits"
     t.integer   "quotes"
     t.datetime  "sales_cycle"
     t.datetime  "estimated_time_cycle"
   end
   
   create table "ranking", :force => true do |t|
     t.integer   "cold_calls"
     t.integer   "visits"
     t.integer   "quotes"
     t.integer   "score"
   end

end
