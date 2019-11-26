# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2017_03_17_021845) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "gem_collector_repositories", id: :serial, force: :cascade do |t|
    t.string "site", null: false
    t.integer "repository_id", null: false
    t.string "full_name", null: false
    t.string "ssh_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site", "repository_id"], name: "idx_repositories", unique: true
  end

  create_table "gem_collector_repository_gems", id: :serial, force: :cascade do |t|
    t.integer "repository_id", null: false
    t.string "name", null: false
    t.string "version", null: false
    t.string "path", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id", "path", "name"], name: "idx_repository_gems", unique: true
  end

end
