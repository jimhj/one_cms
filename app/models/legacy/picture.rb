class Legacy::Picture < Legacy::Base
  self.table_name =  'jk06_uploads'

  belongs_to :article, foreign_key: 'arcid'

  def fullurl
    url = File.join 'http://www.h4.com.cn', self.url
    url.to_s
  end
end