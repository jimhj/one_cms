class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name, limit: 30, null: false
      t.string :slug, limit: 30, null: false
      t.integer :parent_id, null: false, default: 0
      t.string :seo_title, default: nil
      t.string :seo_keywords, default: nil
      t.string :seo_description, default: nil      
      t.timestamps null: false
    end
  end
end
