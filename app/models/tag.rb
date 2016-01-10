class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :articles, through: :taggings 

  validates_presence_of :name
  validates_uniqueness_of :name, on: :create
  validates_uniqueness_of :slug, on: :create

  before_create do
    g_slug
  end

  def g_slug
    self.slug = Pinyin.t(self.name, splitter: '')
    
    if Tag.find_by(slug: self.slug)
      self.slug = "#{self.slug}#{rand(50)}"
    end
  end   
end
