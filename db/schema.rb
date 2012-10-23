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

ActiveRecord::Schema.define(:version => 20121022223956) do

  create_table "match_players", :force => true do |t|
    t.integer  "match_id",                                   :null => false
    t.integer  "player_id",                                  :null => false
    t.boolean  "winner",                  :default => false, :null => false
    t.integer  "team",       :limit => 1,                    :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "match_players", ["match_id", "player_id"], :name => "index_match_players_on_match_id_and_player_id", :unique => true
  add_index "match_players", ["team"], :name => "index_match_players_on_team"

  create_table "matches", :force => true do |t|
    t.integer  "sport_id",                    :null => false
    t.integer  "player_count", :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "name",                         :null => false
    t.string   "office"
    t.string   "match_count", :default => "0", :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "sports", :force => true do |t|
    t.string   "name",                         :null => false
    t.integer  "base_points",   :default => 0, :null => false
    t.integer  "matches_count", :default => 0, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

end
