class Node < ActiveRecord::Base
  has_many :articles
  belongs_to :parent, class_name: 'Node', foreign_key: 'parent_id'
  has_many :children, class_name: 'Node', foreign_key: 'parent_id'

  validates_presence_of :name, :slug
  validates_uniqueness_of :name, :slug
end
