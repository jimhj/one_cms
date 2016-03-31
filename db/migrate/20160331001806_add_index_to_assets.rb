class AddIndexToAssets < ActiveRecord::Migration
  def change
    add_index :redactor_assets, :data_file_name
  end
end
