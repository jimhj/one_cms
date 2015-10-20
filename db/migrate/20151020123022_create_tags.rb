class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, limit: 30, null: false, unique: true
      t.string :slug, limit: 80, null: false
      t.string :seo_title, default: nil
      t.string :seo_keywords, default: nil
      t.string :seo_description, default: nil
      t.integer :taggings_count, default: 0
      t.timestamps null: false
    end
  end
end
