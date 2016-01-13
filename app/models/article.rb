class Article < ActiveRecord::Base
  belongs_to :node
  has_one :article_body, dependent: :destroy
  has_many :taggings
  has_many :tags, through: :taggings

  mount_uploader :thumb, ThumbUploader
  accepts_nested_attributes_for :article_body, allow_destroy: true

  validates_presence_of :node_id, :title

  scope :focus, -> { where(focus: true).order('id DESC').limit(3) }
  scope :hot, -> { where(hot: true).order('id DESC').limit(6) }

  def set_thumb
    imgs = Nokogiri::HTML(self.body_html).css('img').collect{ |img| img[:src] }
    if self.thumb.blank? && imgs.any?
      self.remote_thumb_url = imgs.first
      self.save
      p self.errors.full_messages
    end    
  end

  def self.headline
    hot.first
  end

  def self.topnews
    hot[1..-1]
  end

  def self.pic(limit = 5)
    sql = <<-SQL
      select * from articles
      where thumb is not null
      order by rand()
      limit #{limit}
    SQL

    find_by_sql(sql)
  end

  def self.random(limit = 10)
    sql = <<-SQL
      select * from articles
      where thumb is null
      order by rand()
      limit #{limit}
    SQL

    find_by_sql(sql)    
  end

  def more(limit = 8)
    more = node.articles.where.not(id: id).order('id DESC').limit(limit)
    if more.blank?
      more = Article.where.not(id: id).order('id DESC').limit(2000).sample(8)
    end
    more
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
    article_body.body_html.presence || article_body.body 
  end
end
