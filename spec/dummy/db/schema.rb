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

ActiveRecord::Schema.define(version: 20170323181402) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "gem_collector_latest_gem_versions", force: :cascade do |t|
    t.string   "gem_name",   null: false
    t.string   "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gem_name"], name: "index_gem_collector_latest_gem_versions_on_gem_name", unique: true, using: :btree
  end

  create_table "gem_collector_repositories", force: :cascade do |t|
    t.string   "site",          null: false
    t.integer  "repository_id", null: false
    t.string   "full_name",     null: false
    t.string   "ssh_url",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["site", "repository_id"], name: "idx_repositories", unique: true, using: :btree
  end

  create_table "gem_collector_repository_gems", force: :cascade do |t|
    t.integer  "repository_id", null: false
    t.string   "name",          null: false
    t.string   "version",       null: false
    t.string   "path",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["repository_id", "path", "name"], name: "idx_repository_gems", unique: true, using: :btree
  end

end
