class Article < ActiveRecord::Base
  belongs_to :node
  has_one :article_body, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings

  mount_uploader :thumb, ThumbUploader
  accepts_nested_attributes_for :article_body, allow_destroy: true

  validates_presence_of :node_id, :title

  scope :focus, -> { where(focus: true).order('id DESC').limit(3) }
  scope :hot, -> { where(hot: true, thumb: nil).order('id DESC').limit(6) }

  def set_thumb
    return 0 if not self.thumb.blank?
    imgs = Nokogiri::HTML(self.body_html).css('img').collect{ |img| img[:src] }
    return 1 if not imgs.any?
    img = imgs.first.split(Setting.carrierwave.asset_host + '/').last
    return 2 if img.nil?
    img = Rails.root.join('public', img)
    img = MiniMagick::Image.open(img)
    self.thumb = img
    self.save
  end

  def self.pic(nodes = nil)
    articles = Article.order('thumb DESC, id DESC')
    if nodes.present?
      node_articles = Article.where(node_id: nodes.pluck(:id))
      articles = node_articles if not node_articles.blank?
    end
    articles.limit(5)
  end

  def self.headline
    hot.first
  end

  def self.topnews
    hot[1..-1]
  end

  def analyze_keywords
    rsp = DiscuzKeyword.analyze(title, article_body.body)
    keywords = rsp['total_response']['keyword']['result']['item'].collect{ |h| h.values }.flatten rescue []

    self.tags = keywords.collect do |tag|        
      t = ::Tag.find_or_initialize_by(name: tag)
      t.name = tag
      t.save!
      t
    end

    update_attribute :seo_keywords, keywords.join(',')
  end

  def body_html
    # article_body.body_html.presence || article_body.body 
    article_body.with_keywords
  end
end
