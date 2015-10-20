class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :name, limit: 30, null: false
      t.string :url, limit: 100, null: false
      t.integer :sortrank, default: 1000
      t.timestamps null: false
    end
  end
end
