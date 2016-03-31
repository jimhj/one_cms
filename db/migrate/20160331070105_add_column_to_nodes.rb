class AddColumnToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :nav_name, :string, after: :is_nav
  end
end
