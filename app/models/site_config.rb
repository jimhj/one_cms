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

  def self.init
    config                  = SiteConfig.new
    config.domain           = 'http://www.h4.com.cn'
    config.site_name        = '健康私房话'
    config.site_slogan      = '传播健康知识，倡导健康生活'
    config.site_title       = 'H4传播健康知识，倡导健康生活'
    config.site_keywords    = '健康私房话,H4健康网,H4'
    config.site_description = '健康私房话H4专注健康养生、健康饮食、生活小常识、健康小常识、保健养生知识、健康小知识、男性健康、女性健康等健康服务领域，传播健康知识，倡导健康生活！让健康伴随一生！'
    config.brand_color      = '#ef758e !default'
    config.text_color       = '#454545'
    config.contact_email    = 'service@h4.com.cn'
    config.bd_email         = 'bd@h4.com.cn' 
    config.icp              = '京ICP备11031391号'
    config.copyright        = 'Copyright 2008-2018 健康私房话 www.h4.com.cn 版权所有 京ICP备11031391号'
    config.declare          = '<p>声明：健康私房话所发布的内容来源于网友分享，仅出于分享健康知识，并不意味着赞同其观点或证实其描述。文章内容仅供参考，具体治疗及选购请咨询医生或相关专业人士。</p><p>若有相关问题，请联系 <a class="contact-us" href="mailto:service@h4.com.cn"><i class="fa fa-envelope"></i> service@h4.com.cn</a></p>'
    config.save
  end

  def self.clear_html_cache
    system "cd #{Rails.root.join('public/cached_pages').to_s}; rm -rf *.html"
    system "cd #{Rails.root.join('public/mobile_cached_pages').to_s}; rm -rf *.html"
  end
end
