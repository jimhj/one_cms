require 'nokogiri'

class ArticleBody < ActiveRecord::Base
  belongs_to :article
  validates_presence_of :body

  after_create do
    article.analyze_keywords
  end  

  # after_create do
  #   # 1.提取关键词，加上内链
  #   generate_keyword_links

  #   # 2.把远程图片下载到本地
  #   # restore_remote_images

  #   save
  #   # TODO: use background job
  # end

  def generate_keyword_links
    doc = Nokogiri::HTML(self.body)
    keywords = Keyword.select(:name, :url).each do |keyword|
      ele = doc.xpath("//*[contains(text(), '#{keyword.name}')]").first
      next if ele.nil?
      if ele.name == 'a'
        ele.set_attribute(:href, keyword.url)
        ele.set_attribute(:target, '_blank')
        ele.set_attribute(:css, 'hot-link')
        ele.set_attribute(:title, keyword.name)
      else
        link = Nokogiri::XML::Node.new "a", doc
        link.set_attribute(:href, keyword.url)
        link.set_attribute(:css, 'hot-link')
        link.set_attribute(:target, '_blank')
        link.set_attribute(:title, keyword.name)
        link.content = keyword.name
        ele.inner_html = ele.content.sub(/#{keyword.name}/, link.to_html)
      end
    end

    self.body_html = doc.to_s
  end

  def restore_remote_images
    doc = Nokogiri::HTML(self.body)
    remote_imgs = doc.css('img').collect do |img|
      unless img[:src].include?(CONFIG['carrierwave']['asset_host'])
        picture = RedactorRails.picture_model.new
        url = img[:src]
        if not url.start_with?('http')
          url = File.join('http://www.h4.com.cn', url).to_s
        end
        data = MiniMagick::Image.open(url)
        picture.data = data
        picture.save
        img.set_attribute(:src, picture.url)
        data = nil
      end

      img[:src]
    end

    if article.thumb.blank? && remote_imgs.any?
      article.remote_thumb_url = remote_imgs.first
    end

    self.body = doc.to_s
  end
end
