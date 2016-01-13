class Legacy::Picture < Legacy::Base
  self.table_name =  'jk06_uploads'

  belongs_to :article, foreign_key: 'arcid'

  def fullurl
    url = File.join CONFIG['legacy_image_dir'], self.url
    url.to_s
  end
end