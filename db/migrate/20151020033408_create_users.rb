class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, limit: 30, null: false
      t.string :password_digest, null: false  
      t.string :roles, default: 'admin'    
      t.timestamps null: false
    end
  end
end
