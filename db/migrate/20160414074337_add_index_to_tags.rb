class AddIndexToTags < ActiveRecord::Migration
  def change
    add_index :tags, :taggings_count
  end
end
