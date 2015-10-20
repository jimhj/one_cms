class Node < ActiveRecord::Base
  has_many :articles
  has_many :child_nodes, ->(node) { where(parent_id: node.id) }
  belongs_to :father_node, ->(node) { where(parent_id: node.parent_id) }
end
