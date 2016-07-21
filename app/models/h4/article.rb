class H4::Article < H4::Base
  has_one :article_body
  belongs_to :node
  has_many :taggings
  has_many :tags, through: :taggings
end