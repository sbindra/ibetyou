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

ActiveRecord::Schema.define(:version => 20120522045320) do

  create_table "bets", :force => true do |t|
    t.string   "thebet"
    t.integer  "user_id"
    t.boolean  "betresult"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "betshared",  :default => false
  end

  add_index "bets", ["user_id"], :name => "index_bets_on_user_id"

  create_table "guesses", :force => true do |t|
    t.boolean  "guess"
    t.integer  "user_id"
    t.integer  "bet_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "guesses", ["bet_id"], :name => "index_guesses_on_bet_id"
  add_index "guesses", ["user_id"], :name => "index_guesses_on_user_id"

  create_table "picks", :force => true do |t|
    t.boolean  "pick"
    t.integer  "user_id"
    t.integer  "bet_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "betshared",  :default => false
  end

  add_index "picks", ["bet_id"], :name => "index_picks_on_bet_id"
  add_index "picks", ["user_id"], :name => "index_picks_on_user_id"

  create_table "twitteraccounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "oauth_token"
    t.string   "oauth_token_secret"
    t.string   "oauth_token_verifier"
    t.text     "oauth_authorize_url"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.boolean  "admin",                :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "twittername"
    t.string   "facebookname"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.string   "twitter_token"
    t.string   "twitter_secret"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
