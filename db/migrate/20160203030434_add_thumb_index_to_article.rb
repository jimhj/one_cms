class AddThumbIndexToArticle < ActiveRecord::Migration
  def change
    add_index(:articles, :thumb)
  end
end
