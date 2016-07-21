class H4::Tag < H4::Base
  has_many :taggings
  has_many :articles, through: :taggings 
end