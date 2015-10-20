class Article < ActiveRecord::Base
  belongs_to :node
  has_one :article_body
end
