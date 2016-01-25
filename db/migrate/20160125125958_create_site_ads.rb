class CreateSiteAds < ActiveRecord::Migration
  def change
    create_table :site_ads do |t|
      t.string :key, null: false, index: true
      t.string :title
      t.text :value, null: false
      t.integer :sortrank, default: 50
      t.boolean :active, default: true
      t.timestamps null: false
    end
  end
end
