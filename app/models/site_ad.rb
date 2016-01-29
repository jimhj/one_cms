class SiteAd < ActiveRecord::Base
  validates_presence_of :key, :value

  default_scope {
    order('sortrank DESC, id DESC')
  }

  scope :actived, -> {
    where(active: true)
  }

  def self.types
    {
      'leftsidearticletop'    => '正文内容上方',
      'leftsidearticlebottom' => '正文内容下方',
      'leftsidemiddle'        => '相关文章上方',
      'leftsidebottom'        => '相关文章下方',
      'rightsidetop'          => '右侧上方',
      'rightsidemiddle'       => '右侧中间',
      'rightsidebottom'       => '右侧下方',
      'globalleftright'       => '全站对联广告'
    }    
  end

  class << self
    SiteAd.types.keys.each do |key|
      define_method :"#{key}" do
        where(key: key)
      end      
    end
  end
end
