class ModifyKeywordNameColumn < ActiveRecord::Migration
  def change
    change_column :keywords, :name, :string, limit: 100
  end
end
