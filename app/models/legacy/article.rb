class Legacy::Article < Legacy::Base
  self.table_name = 'jk06_archives'

  has_one :article_body, foreign_key: 'aid'
  has_many :pictures, foreign_key: 'arcid'
  belongs_to :node, foreign_key: 'typeid'

  def tags
    tags = (read_attribute(:keywords) || '').split(',')
    tags.delete('')
    tags.uniq.compact
  end
end