class AddPicturesCountIndexToArticles < ActiveRecord::Migration
  def change
    add_index(:articles, :pictures_count)
  end
end
