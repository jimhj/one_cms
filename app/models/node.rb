class Node < ActiveRecord::Base
  acts_as_nested_set :counter_cache => :children_count

  has_many :articles

  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :slug
end
