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

ActiveRecord::Schema.define(version: 20151020074200) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_bodies", force: :cascade do |t|
    t.integer "article_id",               null: false
    t.text    "body"
    t.string  "redirect_url", limit: 100
  end

  add_index "article_bodies", ["article_id"], name: "index_article_bodies_on_article_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.integer  "node_id",                                 null: false
    t.string   "title",           limit: 200,             null: false
    t.string   "short_title",     limit: 36
    t.integer  "comments_count",              default: 0
    t.integer  "sort_rank",                   default: 0
    t.string   "color",           limit: 10
    t.string   "writer",          limit: 20
    t.string   "source",          limit: 30
    t.string   "seo_keywords",    limit: 60
    t.string   "seo_description", limit: 150
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "articles", ["node_id"], name: "index_articles_on_node_id", using: :btree

  create_table "nodes", force: :cascade do |t|
    t.string   "name",            limit: 30,              null: false
    t.integer  "parent_id",                   default: 0, null: false
    t.string   "seo_title",       limit: 80
    t.string   "seo_keywords",    limit: 60
    t.string   "seo_description", limit: 150
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "login",           limit: 30, null: false
    t.string   "password_digest",            null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

end
