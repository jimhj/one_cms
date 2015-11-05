class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :login, limit: 30, null: false
      t.string :name
      t.string :password_digest, null: false
      t.datetime :last_login_time
      t.string :last_login_ip
      t.string :login_ip
      t.timestamps null: false
    end
  end
end
