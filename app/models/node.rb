class Node < ActiveRecord::Base
  acts_as_nested_set :counter_cache => :children_count

  has_many :articles, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy

  validates_presence_of :name, :slug
  validates_uniqueness_of :slug

  def self.main_slugs
    Setting.main_nodes.keys
  end

  def self.main_node_static
    Setting.main_nodes
  end

  def short_name
    Node.main_node_static[slug]
  end

  def self.main
    where(slug: main_slugs)
  end

  def self.rest
    roots.where.not(slug: main_slugs)
  end

  def headline
    node_ids = self.self_and_descendants.pluck(:id)
    article = Article.where(node_id: node_ids).not(thumb: nil).order('id DESC').first
    article ||= articles.first
    article ||= Article.where.not(thumb: nil).sample
    article
  end
end
