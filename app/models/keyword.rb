class Keyword < ActiveRecord::Base
  validates_presence_of :name, :url, :sortrank
end
