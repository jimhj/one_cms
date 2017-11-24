class Link < ActiveRecord::Base
  belongs_to :linkable, polymorphic: true 
  validates_presence_of :name, :url, :title

  default_scope {
    order('sortrank DESC, id ASC')
  }

  scope :pc, -> {
    where(device: 'PC')
  }

  scope :mobile, -> {
    where(device: 'MOBILE')
  }
end
