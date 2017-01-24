class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :company
      t.string :description
      t.string :website
      t.string :password_digest, null: false
      t.string :email, null: false, index: true
      t.string :mobile
      t.string :logo

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.datetime :locked_at
      t.boolean :activated, default: false

      t.integer :articles_count, default: 0
      t.timestamps null: false
    end
  end
end
