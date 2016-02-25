class Article < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  
  belongs_to :node
  has_one :article_body, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings

  mount_uploader :thumb, ThumbUploader
  accepts_nested_attributes_for :article_body, allow_destroy: true

  validates_presence_of :node_id, :title
  validates_uniqueness_of :title

  scope :recent, -> { order('id DESC').limit(10) }
  scope :focus, -> { where(focus: true).order('id DESC').limit(3) }
  scope :hot, -> { where(hot: true, thumb: nil).order('id DESC').limit(6) }

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
    url = "http://www.h4.com.cn/#{node.slug}/#{id}"
    site = RestClient::Resource.new('http://data.zz.baidu.com')
    begin
      site['urls?site=www.h4.com.cn&token=2yEYwtNjfx5k5sNB'].post url, :content_type => 'text/plain'
    rescue
      true
    end
  end

  def create_keyword
    link = "http://www.h4.com.cn/#{node.slug}/#{id}"
    Keyword.create(name: self.link_word, url: link, sortrank: 1000)
  end

  def set_thumb
    return 0 if not self.thumb.blank?
    imgs = Nokogiri::HTML(self.body_html).css('img').collect{ |img| img[:src] }
    return 1 if not imgs.any?

    imgs.each do |img_src|
      img_path = img_src.split(Setting.carrierwave.asset_host + '/').last
      next if img_path.nil?
      img_url = Rails.root.join('public', img_path)
      img = MiniMagick::Image.open(img_url)

      if img[:width].to_i >= 100 && img[:height].to_i >= 100
        self.thumb = img
        self.save
        break
      else
        next
      end
    end
  end

  def set_pictures_count
    imgs = Nokogiri::HTML(self.body_html).css('img').to_a.select do |img|
      img_path = img[:src].split(Setting.carrierwave.asset_host + '/').last
      if img_path.nil?
        false
      else
        img_url = Rails.root.join('public', img_path)
        img = MiniMagick::Image.open(img_url)        
        img[:width].to_i >= 100 && img[:height].to_i >= 100
      end
    end

    update_column :pictures_count, imgs.count
  end

  def set_description
    self.seo_description = strip_tags(article_body.body).first(200)
    self.save
  end

  def seo_description
    read_attribute(:seo_description) || strip_tags(article_body.try(:body) || '').first(200)
  end

  def self.pic(article = nil)
    if article.nil?
      node_ids = Node.all.pluck(:id)
      node_ids = node_ids.sample(10)
    else
      node_ids = article.node.root.self_and_descendants.pluck(:id)
    end
    articles = Article.where(node_id: node_ids).order('thumb DESC, id DESC')
    articles.limit(5)
  end

  def self.headline
    hot.first
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

  def hidden_thumb
    # pic = pictures.first
    # pic ||= RedactorRails::Picture.where('width >= 121 and height >= 75')
  end

  def pictures
    Rails.cache.fetch([self.id, 'pic_urls']) do
      srcs = Nokogiri::HTML(article_body.body).css('img').collect { |img| img[:src] }.select do |src| 
        valid_src = src.include?(Setting.carrierwave.asset_host)

        img_path = src.split(Setting.carrierwave.asset_host + '/').last
        valid_demission = if img_path.nil?
          false
        else
          img_url = Rails.root.join('public', img_path)
          img = MiniMagick::Image.open(img_url) rescue false    
          demission = img && img[:width].to_i >= 100 && img[:height].to_i >= 100
          img = nil
          demission
        end  
        
        valid_src && valid_demission    
      end

      # if self.pictures_count < 0
      #   self.update_column :pictures_count, srcs.size
      # end

      srcs
    end
  end

  def next
    Article.where("id < ?", id).order("id DESC").first
  end

  def prev
    Article.where("id > ?", id).order("id ASC").first
  end

  def body_html
    # article_body.body_html.presence || article_body.body
    article_body.replace_keywords
  end

  def keywords
    seo_keywords.split(/,|，/)
  end
end
