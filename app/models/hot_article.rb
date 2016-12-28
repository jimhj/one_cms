class HotArticle < ActiveRecord::Base
  validates_presence_of :link, :title
  scope :hot, -> { where(active: true).order('sortrank DESC, id DESC').limit(3) }
end
