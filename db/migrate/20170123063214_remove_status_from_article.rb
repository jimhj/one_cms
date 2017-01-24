class RemoveStatusFromArticle < ActiveRecord::Migration
  def change
    remove_columns :articles, :status
  end
end
