class AddColoumnRecommendToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :recommend, :boolean, after: :hot, default: false, index: true   
  end
end
