class SiteConfig < ActiveRecord::Base
  mount_uploader :logo, ThumbUploader, mount_on: :site_logo
  mount_uploader :mobile_logo, ThumbUploader, mount_on: :mobile_logo
  mount_uploader :favicon, FaviconUploader, mount_on: :favicon

  store :extras, accessors: [:brand_color, :text_color, :contact_email, :bd_email, :icp, :declare, :copyright, :domain]
  validates_presence_of :site_name, :site_title, :site_slogan, :domain

  def self.actived
    self.first
  end
end
