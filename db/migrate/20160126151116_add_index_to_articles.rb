class AddIndexToArticles < ActiveRecord::Migration
  def change
    add_index(:articles, :title)
  end
end
