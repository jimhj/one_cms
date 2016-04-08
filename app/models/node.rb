class Node < ActiveRecord::Base
  acts_as_nested_set :counter_cache => :children_count

  has_many :articles, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy

  validates_presence_of :name, :slug
  validates_uniqueness_of :slug

  def self.rest
    roots.where(is_nav: false)
  end

  def short_name
    nav_name.presence || name
  end

  def headline
    articles = descendants_articles.order('id DESC')
    article = descendants_articles.where.not(thumb: nil).first
    article ||= articles.first
    article ||= Article.where.not(thumb: nil).sample
  end

  def descendants_articles
    node_ids = self.self_and_descendants.pluck(:id)
    Article.where(node_id: node_ids).where.not(thumb: nil).order('id DESC, thumb DESC')
  end
end
