class AddNavbarColumnToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :is_nav, :boolean, after: :sortrank, default: false
  end
end
