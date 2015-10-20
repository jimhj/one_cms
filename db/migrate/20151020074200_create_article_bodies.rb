class CreateArticleBodies < ActiveRecord::Migration
  def change
    create_table :article_bodies do |t|
      t.belongs_to :article, index: true, null: false
      t.text :body
      t.string :redirect_url, limit: 100, default: nil
    end
  end
end
