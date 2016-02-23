class AddPicturesCountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :pictures_count, :integer, after: :link_word, default: -1
  end
end
