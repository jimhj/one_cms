class CreateHotArticles < ActiveRecord::Migration
  def change
    create_table :hot_articles do |t|
      t.string :title, limit: 200, null: false
      t.string :link, null: false
      t.integer :sortrank, default: 1000
      t.boolean :active, default: true
      t.timestamps null: false
    end
  end
end
