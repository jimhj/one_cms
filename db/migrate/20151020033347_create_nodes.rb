class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name, limit: 30, null: false
      t.string :slug, limit: 30, null: false
      t.integer :parent_id, null: false, default: 0
      t.string :seo_title, limit: 80, default: nil
      t.string :seo_keywords, limit: 60, default: nil
      t.string :seo_description, limit: 150, default: nil      
      t.timestamps null: false
    end
  end
end
