class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :name, limit: 30, null: false
      t.string :title, limit: 150, default: nil
      t.string :url, limit: 150, null: false
      t.string :qq, limit: 20, default: nil
      t.integer :sortrank, default: 1000
      t.integer :status, default: 0
      t.timestamps null: false
    end
  end
end
