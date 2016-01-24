class Channel < ActiveRecord::Base
  has_many :channel_articles, dependent: :destroy
  has_many :articles, through: :channel_articles

  validates_presence_of :name, :seo_keywords
  validates_uniqueness_of :name

  before_create do
    g_slug
  end

  after_create do
    self.delay.check_articles
  end

  def check_articles
    conditions = keywords.collect do |keyword|
      "title like '%#{keyword}%'"
    end.join(' or ')

    self.articles = Article.where(conditions)
  end

  def keywords
    (self.seo_keywords || '').split(/,|，/)
  end

  def g_slug
    self.slug = Pinyin.t(self.name, splitter: '')
    
    if Channel.find_by(slug: self.slug)
      self.slug = "#{self.slug}#{rand(50)}"
    end
  end

  def self.hot(keywords = nil)
    keywords ||= Setting.main_nodes.values.join(',')
    keywords = keywords.split(/,|，|\s/)
    subsql = keywords.collect do |keyword|
      "name like '%#{keyword}%'"
    end.join(' or ')

    hots = self.where(subsql).order('id ASC')
    if hots.blank?
      hots = self.order('id ASC')
    end
    
    hots.limit(10)
  end   
end
