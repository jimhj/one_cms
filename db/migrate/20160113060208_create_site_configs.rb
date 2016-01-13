class CreateSiteConfigs < ActiveRecord::Migration
  def change
    create_table :site_configs do |t|
      t.string :key, null: false, index: true
      t.string :key_name, null: false
      t.text :value
      t.timestamps null: false
    end
  end
end
