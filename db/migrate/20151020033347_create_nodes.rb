class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name, limit: 30, null: false
      t.string :slug, limit: 30, null: false
      t.integer :parent_id, null: false
      t.integer :rgt
      t.integer :depth
      t.integer :children_count
      t.string :seo_title, default: nil
      t.string :seo_keywords, default: nil
      t.string :seo_description, default: nil
      t.integer :sortrank, default: 1000
      t.timestamps null: false
    end
  end
end
