require 'nokogiri'

class ArticleBody < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  belongs_to :article
  validates_presence_of :body

  before_create do
    restore_remote_images
  end

  after_create do
    article.delay.analyze_keywords
    article.delay.set_thumb
    
    if article.seo_description.blank?
      article.set_description
    end
  end

  # def replace_keywords
  #   keywords = Keyword.order('id DESC, sortrank DESC').select(:id, :name, :url)
  #   # if not cached_keyword_id.zero?
  #   #   keywords = keywords.where('id > ?', cached_keyword_id)
  #   # end
  #   # keywords = keywords.limit(5000)

  #   # return self.body_html if keywords.blank?
    
  #   keywords.each do |keyword|
  #     doc = Nokogiri::HTML(self.body_html.presence || self.body)
  #     ele = doc.xpath("//*[contains(text(), '#{keyword.name}')]").first
  #     next if ele.nil?
  #     next if ele.name == 'a'
  #     link = Nokogiri::XML::Node.new "a", doc
  #     link.set_attribute(:href, keyword.url)
  #     link.set_attribute(:css, 'hot-link')
  #     link.set_attribute(:target, '_blank')
  #     link.set_attribute(:title, keyword.name)
  #     link.content = keyword.name
  #     ele.content = ele.content.sub(/#{keyword.name}/, link.to_html)
  #     ele.inner_html = ele.content.to_s
  #     self.body_html = doc.to_html
  #   end

  #   # update_columns(cached_keyword_id: keywords.first.try(:id) || 0, body_html: doc.to_html)

  #   self.body_html
  # end

  def replace_keywords
    keywords = Keyword.select(:id, :name, :url)
    if not cached_keyword_id.zero?
      keywords = keywords.where('id > ?', cached_keyword_id)
    end
    keywords = keywords.limit(10000)
    
    return self.body_html if keywords.blank?

    keywords.each do |kw|
      link = "<a href='#{kw.url}' class='hot-link' target='_blank'>#{kw.name}</a>"
      self.body_html = (self.body_html.presence || self.body).sub(kw.name, link)
    end

    update_columns(cached_keyword_id: keywords.first.try(:id) || 0, body_html: self.body_html)
    self.body_html
  end


  def restore_remote_images
    doc = Nokogiri::HTML(self.body)
    remote_imgs = doc.css('img').collect do |img|
      begin
        if not img[:src].include?(Setting.carrierwave.asset_host)
          picture = RedactorRails.picture_model.new
          url = img[:src]

          # if not url.start_with?('http')
          #   url = File.join(Setting.legacy_image_dir, url).to_s
          # end

          data = MiniMagick::Image.open(url)
          picture.data = data
          picture.save
          img.set_attribute(:src, picture.url)
          data = nil
        end

        img[:src]
      rescue => e
        next
      end
    end.compact

    self.body = doc.to_s
  end
end
