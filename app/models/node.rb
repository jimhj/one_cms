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
end
