class AddColumnsToSiteConfig < ActiveRecord::Migration
  def change
    add_column :site_configs, :mobile_logo, :string, after: :site_logo
    add_column :site_configs, :favicon, :string, after: :mobile_logo
  end
end
