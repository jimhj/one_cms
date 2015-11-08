class Article < ActiveRecord::Base
  belongs_to :node
  has_one :article_body
  has_many :taggings
  has_many :tags, through: :taggings

  accepts_nested_attributes_for :article_body, allow_destroy: true

  validates_presence_of :node_id, :title
end
