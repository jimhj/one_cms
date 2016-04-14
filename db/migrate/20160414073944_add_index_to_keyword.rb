class AddIndexToKeyword < ActiveRecord::Migration
  def change
    add_index :keywords, :sortrank
  end
end
