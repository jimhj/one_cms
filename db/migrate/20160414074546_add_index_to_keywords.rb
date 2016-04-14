class AddIndexToKeywords < ActiveRecord::Migration
  def change
    add_index :keywords, [:id, :sortrank]
  end
end
