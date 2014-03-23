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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140309001604) do

  create_table "api_keys", :force => true do |t|
    t.string   "access_token"
    t.datetime "expires_at"
    t.integer  "user_id"
    t.boolean  "active"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "api_keys", ["access_token"], :name => "index_api_keys_on_access_token", :unique => true
  add_index "api_keys", ["user_id"], :name => "index_api_keys_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "destinations", :force => true do |t|
    t.string   "start"
    t.string   "dst"
    t.integer  "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "destinations", ["start", "dst"], :name => "index_destinations_on_start_and_dst"

  create_table "items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.integer  "category_id"
    t.integer  "quantity"
    t.integer  "weight"
    t.integer  "price"
    t.string   "describe"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "items", ["user_id", "order_id", "category_id"], :name => "index_items_on_user_id_and_order_id_and_category_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "destination_id"
    t.integer  "price"
    t.string   "state"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "carrier_id"
    t.string   "nowlocation"
    t.string   "allshippingdetail"
    t.string   "receiverfirstname"
    t.string   "receiversecondname"
    t.string   "receiveraddress"
    t.string   "receivertel"
    t.string   "receivemethod"
    t.boolean  "iscomplete"
  end

  add_index "orders", ["user_id", "created_at"], :name => "index_orders_on_user_id_and_created_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "role"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "telephone"
    t.string   "address"
    t.string   "bankinfo"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
