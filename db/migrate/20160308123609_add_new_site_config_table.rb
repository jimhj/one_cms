class AddNewSiteConfigTable < ActiveRecord::Migration
  def change
    create_table :site_configs do |t|
      t.string :site_name, null: false
      t.string :site_slogan
      t.string :site_title, null: false
      t.string :site_keywords
      t.string :site_description
      t.string :site_logo
      t.text :extras
      t.boolean :active, default: true
    end
  end
end
