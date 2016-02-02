class AddCachedColumnsToArticles < ActiveRecord::Migration
  def change
    add_column :article_bodies, :cached_keyword_id, :integer, after: :body_html, default: 0
  end
end
