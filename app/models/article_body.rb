class ArticleBody < ActiveRecord::Base
  belongs_to :article

  before_save do
  end
end
