class AddUserIdToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :user_id, :integer, after: :id, default: 0, index: true
    add_column :articles, :approved, :boolean, after: :status, default: false, index: true
  end
end
