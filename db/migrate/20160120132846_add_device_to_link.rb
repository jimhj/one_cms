class AddDeviceToLink < ActiveRecord::Migration
  def change
    add_column :links, :device, :string, default: 'PC', after: :status
  end
end
