class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name, null: false
      t.string :slug, index: true, null: false
      t.string :seo_keywords
      t.string :seo_description
      t.integer :sortrank, default: 1000
      t.timestamps null: false
    end
  end
end
