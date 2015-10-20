class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      # t.belongs_to :node, index: true, null: false
      # t.text :body, null: false
      # t.string :redirect_url, default: nil
      # t.string :userip, default: nil
      # t.string :seo_title, default: nil
      # t.string :seo_keywords, default: nil
      # t.string :seo_description, default: nil
      # t.timestamps null: false
    end
  end
end
