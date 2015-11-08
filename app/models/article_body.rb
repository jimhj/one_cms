class ArticleBody < ActiveRecord::Base
  belongs_to :article
  validates_presence_of :body

  before_save do
    # 1.提取关键词，加上内链
    # 2.把远程图片下载到本地
    self.body_html ||= self.body
    keywords = Keyword.select(:name, :url).each do |keyword|
      self.body_html = self.body_html.sub(
        /#{keyword.name}/,
        %Q(<a href="#{keyword.url}" target="_blank" title="#{keyword.name}">#{keyword.name}</a>)
      )
    end
  end
end
