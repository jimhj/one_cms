class Keyword < ActiveRecord::Base
  validates_presence_of :name, :url, :sortrank
  validates_uniqueness_of :name

  # default_scope {
  #   order('sortrank DESC, LENGTH(name) DESC, id DESC')
  # }

  def self.recent
    self.order('id DESC').limit(1).first
  end
end
