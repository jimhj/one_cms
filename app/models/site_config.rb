class SiteConfig < ActiveRecord::Base
  mount_uploader :logo, ThumbUploader, mount_on: :site_logo
  mount_uploader :mobile_logo, ThumbUploader, mount_on: :mobile_logo
  mount_uploader :favicon, FaviconUploader, mount_on: :favicon

  store :extras, accessors: [:background_color, :brand_color, :text_color, :theme, :contact_email, :bd_email, :icp, :declare, :copyright, :domain]
  validates_presence_of :site_name, :site_title, :site_slogan, :domain

  after_save do
    Rails.cache.delete 'site_config'
  end

  def self.actived
    Rails.cache.fetch 'site_config' do
      SiteConfig.first
    end
  end
end
