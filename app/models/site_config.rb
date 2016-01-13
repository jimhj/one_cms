class SiteConfig < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
 
  class << self
    SiteConfig.all.each do |conf|
      define_method :"#{conf.key}" do
        conf.value
      end
    end
  end
end
