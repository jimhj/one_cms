class Legacy::ArticleBody < Legacy::Base
  self.table_name = 'jk06_addonarticle'

  belongs_to :article, foreign_key: 'aid'
end