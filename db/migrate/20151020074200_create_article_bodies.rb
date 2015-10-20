class CreateArticleBodies < ActiveRecord::Migration
  def change
    create_table :article_bodies do |t|

      t.timestamps null: false
    end
  end
end
