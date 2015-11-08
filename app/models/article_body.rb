class ArticleBody < ActiveRecord::Base
  belongs_to :article

  before_save do
    # 1.提取关键词，加上内链
    # 2.把远程图片下载到本地
  end
end
