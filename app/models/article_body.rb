require 'nokogiri'

class ArticleBody < ActiveRecord::Base
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

  def replace_keywords
    update_column(:body_html, nil) if cached_keyword_id.zero?

    keywords = Keyword.order('id DESC').select(:id, :name, :url)
    if not cached_keyword_id.zero?
      keywords = keywords.where('id > ?', cached_keyword_id)
    end
    keywords = keywords.limit(5000)

    return self.body_html if keywords.blank?
    
    doc = Nokogiri::HTML(self.body_html.presence || self.body)
    keywords.each do |keyword|
      ele = doc.xpath("//p[contains(text(), '#{keyword.name}')]").first
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
    update_columns(cached_keyword_id: keywords.first.id, body_html: doc.to_s)

    doc.to_s
  end

  # def cached_keyword_id
    
  # end

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
        # raise e
        next
      end
    end.compact

    self.body = doc.to_s
  end
end
