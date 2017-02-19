class Article < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  
  belongs_to :node
  has_one :article_body, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :picture_assets, -> { where('height >= 100 and width >= 100').order('created_at DESC') }, as: :assetable, class_name: 'RedactorRails::Picture'

  mount_uploader :thumb, ThumbUploader
  accepts_nested_attributes_for :article_body, allow_destroy: true

  validates_presence_of :node_id, :title
  validates_uniqueness_of :title

  scope :recent, -> { where(recommend: false).order('id DESC').limit(6) }
  scope :focus, -> { where(focus: true).order('id DESC').limit(3) }
  scope :hot, -> { with_photo.where(hot: true).order('id DESC').limit(8) }

  scope :with_photo, -> {
    where('pictures_count > 0')
  }
  
  scope :photo_news, -> {
    where(hot: false).with_photo.order('id DESC').limit(6)
  }

  after_create do
    if self.linked?
      self.delay.create_keyword
    end

    self.delay.notify_baidu_spider
  end

  after_update do
    if (changed_attributes.keys.include?('linked') or changed_attributes.keys.include?('link_word')) && self.linked?
      self.delay.create_keyword
    end
  end

  def notify_baidu_spider
    return if node.blank?

    uri = URI.parse("http://data.zz.baidu.com/urls?site=#{SiteConfig.actived.domain}&token=#{Setting.baidu_notify_token}")
    req = Net::HTTP::Post.new(uri.request_uri)

    url = "http://#{SiteConfig.actived.domain}/#{node.slug}/#{id}"
    req.body = url
    req.content_type = 'text/plain'

    Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
  end

  def create_keyword
    link = "http://#{SiteConfig.actived.domain}/#{node.slug}/#{id}"
    Keyword.create(name: self.link_word, url: link, sortrank: 1000)
  end

  def set_description
    self.seo_description = strip_tags(article_body.body).first(200)
    self.save
  end

  def seo_description
    read_attribute(:seo_description) || strip_tags(article_body.try(:body) || '').first(200)
  end

  def self.topnews
    hot[1..-1]
  end

  def analyze_keywords
    begin
      rsp = DiscuzKeyword.analyze(title, article_body.body)
      keywords = rsp['total_response']['keyword']['result']['item'].collect{ |h| h.values }.flatten rescue []

      self.tags = keywords.collect do |tag|        
        t = ::Tag.find_or_initialize_by(name: tag)
        t.name = tag
        t.save!
        t
      end

      update_attribute :seo_keywords, keywords.join(',')
    rescue
      true
    end
  end


  def pictures
    pictures = self.picture_assets

    return [] if article_body.nil?
    
    if pictures.blank?
      filenames = Nokogiri::HTML(article_body.body).css('img').collect do |img|
        src = img[:src]
        next if src.nil?

        split_host = nil

        if src.include?(Setting.carrierwave.asset_host)
          split_host = Setting.carrierwave.asset_host
        end

        if Setting.carrierwave.legacy_asset_host.present?
          if src.include?(Setting.carrierwave.legacy_asset_host)
            split_host = Setting.carrierwave.legacy_asset_host
          end
        end

        next if split_host.nil?

        img_path = src.split(split_host + '/').last
        img_path.split('/').last(2).join('/')
      end.compact

      pictures = RedactorRails::Picture.where(data_file_name: filenames).where('width >= 100 and height >= 100')
      pictures.update_all(assetable_type: self.class.name, assetable_id: self.id)
      self.update_column(:pictures_count, pictures.count)
    end

    pictures.collect { |pic| pic.qn_url(:thumb) }
  end

  def next
    Article.where("id < ?", id).order("id DESC").first
  end

  def prev
    Article.where("id > ?", id).order("id ASC").first
  end

  def add_watermark_to_html_images(html)
    doc = Nokogiri::HTML(html)
    doc.css('img').each do |img|
      begin
        src = img[:src]
        if src.nil?
          img.remove
          next
        end

        if Setting.carrierwave["legacy_asset_host"].present?
          src = src.gsub(Setting.carrierwave.legacy_asset_host, Setting.qiniu.mirror_host)
        end
        
        src = src.gsub(Setting.carrierwave.asset_host, Setting.qiniu.mirror_host)
        img.set_attribute(:src, "#{src}!content")
      rescue => e
        next
      end
    end
    doc.to_s
  end

  def body_html
    html = article_body.body_html.presence || article_body.body
    article_body.delay.replace_keywords rescue nil
    add_watermark_to_html_images(html)
  end

  def keywords
    seo_keywords.split(/,|，/)
  end

  def self.recommend(page: 1, load: 20)
    page = page.to_i
    init_offset = 20
    if page == 1
      offset = 0
    elsif page > 1
      offset = load * (page - 1) + init_offset
    end

    recommends = self.where(recommend: true).order('id DESC').offset(offset).limit(load)

    # if recommends.count < load
    #   needs = self.where.not(id: recommends.pluck(:id)).order('id DESC').offset(offset).limit(load - recommends.count)
    # else
    #   needs = []
    # end
    # recommends = recommends.to_a + needs.to_a
  end

  def format_seo_title
    seo_title = self.seo_title.presence || ''
    if seo_title.start_with?(self.title)
      seo_title = seo_title.sub(self.title, '')
    end

    seo_title = [self.title, seo_title]
    seo_title -= ['', nil]
    seo_title.join    
  end

  def source
    s = read_attribute(:source)
    s.presence || '网友'
  end
end
