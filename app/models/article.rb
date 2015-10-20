class Article < ActiveRecord::Base
  belongs_to :node
  has_one :article_body
  has_many :taggings
  has_many :tags, through: :taggings  
end
