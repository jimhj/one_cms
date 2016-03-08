class SiteConfig < ActiveRecord::Base
  mount_uploader :logo, ThumbUploader, mount_on: :site_logo
  store :extras, accessors: [:brand_color, :text_color, :contact_email, :bd_email, :icp, :declare, :copyright, :domain]
  validates_presence_of :site_name, :site_title, :site_slogan, :domain

  def self.actived
    self.first
  end
end
