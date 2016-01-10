class Article < ActiveRecord::Base
  belongs_to :node
  has_one :article_body
  has_many :taggings
  has_many :tags, through: :taggings

  mount_uploader :thumb, ThumbUploader
  accepts_nested_attributes_for :article_body, allow_destroy: true

  validates_presence_of :node_id, :title

  scope :focus, -> { where(focus: true).order('id DESC').limit(3) }
end
