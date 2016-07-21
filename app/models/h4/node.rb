class H4::Node < H4::Base
  acts_as_nested_set
  has_many :articles
end