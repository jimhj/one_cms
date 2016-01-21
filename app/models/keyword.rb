class Keyword < ActiveRecord::Base
  validates_presence_of :name, :url, :sortrank

  def self.recent
    self.order('created_at DESC, updated_at DESC').limit(1).first
  end
end
