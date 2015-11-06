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

ActiveRecord::Schema.define(version: 20151027143928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "login",           limit: 30, null: false
    t.string   "name"
    t.string   "password_digest",            null: false
    t.datetime "last_login_time"
    t.string   "last_login_ip"
    t.string   "login_ip"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "article_bodies", force: :cascade do |t|
    t.integer "article_id",               null: false
    t.text    "body"
    t.text    "body_html"
    t.string  "redirect_url", limit: 100
  end

  add_index "article_bodies", ["article_id"], name: "index_article_bodies_on_article_id", using: :btree

  create_table "articles", force: :cascade do |t|
    t.integer  "node_id",                                     null: false
    t.string   "title",           limit: 200,                 null: false
    t.string   "short_title",     limit: 80
    t.integer  "comments_count",              default: 0
    t.integer  "sort_rank",                   default: 0
    t.string   "color",           limit: 10
    t.string   "writer",          limit: 20
    t.string   "thumb"
    t.string   "source",          limit: 30
    t.string   "seo_title"
    t.string   "seo_keywords"
    t.string   "seo_description"
    t.boolean  "hot",                         default: false
    t.integer  "status",                      default: 0
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "articles", ["hot"], name: "index_articles_on_hot", using: :btree
  add_index "articles", ["node_id"], name: "index_articles_on_node_id", using: :btree

  create_table "channel_articles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "channels", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keywords", force: :cascade do |t|
    t.string   "name",       limit: 30,                 null: false
    t.string   "url",        limit: 100,                null: false
    t.integer  "sortrank",               default: 1000
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "links", force: :cascade do |t|
    t.integer  "linkable_id"
    t.string   "linkable_type"
    t.string   "name",          limit: 30,                 null: false
    t.string   "title",         limit: 150
    t.string   "url",           limit: 150,                null: false
    t.string   "qq",            limit: 20
    t.integer  "sortrank",                  default: 1000
    t.integer  "status",                    default: 0
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "links", ["linkable_type", "linkable_id"], name: "index_links_on_linkable_type_and_linkable_id", using: :btree

  create_table "nodes", force: :cascade do |t|
    t.string   "name",            limit: 30,                null: false
    t.string   "slug",            limit: 30,                null: false
    t.integer  "parent_id",                                 null: false
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "children_count"
    t.string   "seo_title"
    t.string   "seo_keywords"
    t.string   "seo_description"
    t.integer  "sortrank",                   default: 1000
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "redactor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "redactor_assets", ["assetable_type", "assetable_id"], name: "idx_redactor_assetable", using: :btree
  add_index "redactor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_redactor_assetable_type", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "tag_id"
    t.datetime "created_at"
  end

  add_index "taggings", ["article_id", "tag_id"], name: "index_taggings_on_article_id_and_tag_id", using: :btree
  add_index "taggings", ["article_id"], name: "index_taggings_on_article_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",            limit: 30,             null: false
    t.string   "slug",            limit: 80,             null: false
    t.string   "seo_title"
    t.string   "seo_keywords"
    t.string   "seo_description"
    t.integer  "taggings_count",             default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

end
