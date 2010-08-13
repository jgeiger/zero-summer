# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 12) do

  create_table "absences", :force => true do |t|
    t.integer  "member_id"
    t.date     "event_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "absences", ["event_date"], :name => "index_absences_on_event_date"
  add_index "absences", ["member_id"], :name => "index_absences_on_member_id"

  create_table "adjustments", :force => true do |t|
    t.integer  "amount"
    t.integer  "member_id"
    t.integer  "loot_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adjustments", ["loot_id"], :name => "index_adjustments_on_loot_id"
  add_index "adjustments", ["member_id"], :name => "index_adjustments_on_member_id"

  create_table "bosses", :force => true do |t|
    t.string   "name",       :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drops", :force => true do |t|
    t.integer  "encounter_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "drops", ["encounter_id"], :name => "index_drops_on_encounter_id"
  add_index "drops", ["item_id"], :name => "index_drops_on_item_id"

  create_table "dungeons", :force => true do |t|
    t.string   "name",       :limit => 100
    t.string   "token",      :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dungeons", ["token"], :name => "index_dungeons_on_token"

  create_table "encounters", :force => true do |t|
    t.integer  "dungeon_id"
    t.integer  "boss_id"
    t.string   "difficulty", :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "encounters", ["boss_id"], :name => "index_encounters_on_boss_id"
  add_index "encounters", ["difficulty"], :name => "index_encounters_on_difficulty"
  add_index "encounters", ["dungeon_id"], :name => "index_encounters_on_dungeon_id"

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "quality"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loots", :force => true do |t|
    t.string   "status",     :limit => 20
    t.integer  "member_id"
    t.integer  "raid_id"
    t.integer  "drop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loots", ["drop_id"], :name => "index_loots_on_drop_id"
  add_index "loots", ["member_id"], :name => "index_loots_on_member_id"
  add_index "loots", ["raid_id"], :name => "index_loots_on_raid_id"
  add_index "loots", ["status"], :name => "index_loots_on_status"

  create_table "members", :force => true do |t|
    t.string   "name",       :limit => 50
    t.string   "klass",      :limit => 20
    t.string   "role",       :limit => 20
    t.string   "rank",       :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["klass"], :name => "index_members_on_klass"
  add_index "members", ["rank"], :name => "index_members_on_rank"
  add_index "members", ["role"], :name => "index_members_on_role"

  create_table "raid_memberships", :force => true do |t|
    t.integer  "member_id"
    t.integer  "raid_id"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "raid_memberships", ["active"], :name => "index_raid_memberships_on_active"
  add_index "raid_memberships", ["member_id"], :name => "index_raid_memberships_on_member_id"
  add_index "raid_memberships", ["raid_id"], :name => "index_raid_memberships_on_raid_id"

  create_table "raids", :force => true do |t|
    t.string   "name",       :limit => 50
    t.date     "event_date"
    t.boolean  "active",                   :default => false
    t.boolean  "mandatory",                :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "raids", ["active"], :name => "index_raids_on_active"
  add_index "raids", ["event_date"], :name => "index_raids_on_event_date"
  add_index "raids", ["mandatory"], :name => "index_raids_on_mandatory"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "password_salt",                       :default => "",    :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                               :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
