class AddInnerLinksToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :linked, :boolean, :after => :status, :default => false
    add_column :articles, :link_word, :string, after: :linked, default: nil
  end
end
