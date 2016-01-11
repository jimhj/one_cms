class Link < ActiveRecord::Base
  belongs_to :linkable, polymorphic: true 
  validates_presence_of :name, :url, :title

  default_scope {
    order('sortrank DESC, id DESC')
  }
end
